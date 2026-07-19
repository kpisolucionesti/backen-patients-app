namespace :import_legacy_data do
  desc "Import legacy data from the 'legacy' schema into the current schema"
  task import: :environment do
    unless ActiveRecord::Base.connection.table_exists?('legacy.patients')
      puts "ERROR: Schema 'legacy' not found or empty. Load the SQL dump first:"
      puts "  1. sed 's/public\\./legacy./g; s/ SCHEMA public/ SCHEMA legacy/g; /OWNER TO pg_database_owner/d' patient_db-20260715.sql | docker exec -i postgres-db psql -U postgres -d patient_db"
      exit 1
    end

    ActiveRecord::Base.transaction do
      puts "=== Step 1: Ensure admin user exists ==="
      admin = create_admin_user!
      puts "  Admin: #{admin.email} (id=#{admin.id})"

      puts "\n=== Step 2: Ensure doctors exist ==="
      import_doctors!

      puts "\n=== Step 3: Import patients ==="
      import_patients!(admin)

      puts "\n=== Step 4: Create emergencies ==="
      import_emergencies!(admin)

      puts "\n=== Step 5: Link emergency doctors ==="
      import_emergency_doctors!

      puts "\n=== Step 6: Import notes ==="
      import_notes!

      puts "\n=== DONE ==="
    end
  end

  # ── Legacy models (read-only, point to 'legacy' schema) ──

  class LegacyPatient < ActiveRecord::Base
    self.table_name = 'legacy.patients'
    self.primary_key = 'id'
  end

  class LegacyNote < ActiveRecord::Base
    self.table_name = 'legacy.notes'
    self.primary_key = 'id'
  end

  class LegacyDoctor < ActiveRecord::Base
    self.table_name = 'legacy.doctors'
    self.primary_key = 'id'
  end

  # ── Helpers ──

  def create_admin_user!
    profile = Profile.find_by(name: 'Administrador') ||
              Profile.create!(
                name: 'Administrador',
                description: 'Acceso completo a todos los modulos',
                permissions: ALL_PERMISSIONS
              )

    User.find_or_create_by!(email: 'admin@emerboard.com') do |u|
      u.username = 'admin'
      u.password = 'Admin123456!'
      u.password_confirmation = 'Admin123456!'
      u.name = 'Admin'
      u.profile = profile
      u.status = 'active'
      u.confirmed_at = Time.current
    end
  end

  def ALL_PERMISSIONS
    %w[
      emergencia.view emergencia.create emergencia.edit
      emergencia.triage emergencia.discharge
      historial.view historial.export
      configuraciones.view
      pacientes.view pacientes.edit
      medicos.view medicos.create medicos.edit medicos.suspend
      usuarios.view usuarios.create usuarios.edit
      usuarios.suspend usuarios.manage_permissions usuarios.change_password
      perfiles.view perfiles.create perfiles.edit perfiles.delete
      rooms.view
      notes.view notes.create notes.edit notes.delete
      emergencia.assign_room
      especialidades.view especialidades.create especialidades.edit especialidades.delete
      agenda.edit
      citas.view citas.create citas.edit citas.delete citas.attend
    ]
  end

  def find_or_create_specialty(name)
    Specialty.find_or_create_by!(name: name.upcase.strip) do |s|
      s.description = "Especialidad de #{name.downcase.strip}"
    end
  end

  def import_doctors!
    Doctor.update_all(status: 'active')

    doctor_names = LegacyDoctor.pluck(:name, :speciality).to_h

    patient_doctors = LegacyPatient.where.not(current_doctor: [nil, ''])
                                   .distinct
                                   .pluck(:current_doctor)
                                   .map { |n| clean_doctor_name(n) }
                                   .uniq

    existing = Doctor.pluck(:name).map(&:strip).map(&:upcase).to_set

    created = 0
    patient_doctors.each do |name|
      next if existing.include?(name.upcase.strip)

      speciality_name = doctor_names[name] || 'GENERAL'
      specialty = find_or_create_specialty(speciality_name)
      Doctor.create!(name: name.strip, specialty: specialty, status: 'active')
      created += 1
    end

    puts "  Doctors created: #{created}, total: #{Doctor.count}"
  end

  def import_patients!(admin)
    old_count = LegacyPatient.count
    imported = 0
    skipped = 0
    old_to_new = {}

    LegacyPatient.find_each do |old|
      raw_ci = old.ci.to_s.strip
      raw_ci = nil if raw_ci.blank? || raw_ci == '\\N'

      ci = raw_ci.present? ? raw_ci.gsub(/\D/, '') : nil
      if ci.blank?
        ci = "TEMP-#{old.id}"
      end

      first_name, *rest = old.name.to_s.strip.split(/\s+/)
      lastname = rest.empty? ? nil : rest.join(' ')

      attrs = {
        name: first_name || '',
        lastname: lastname,
        gender: old.gender,
        birthday: nil,
        created_at: old.created_at,
        updated_at: old.updated_at,
        created_by_id: admin&.id
      }

      begin
        new_patient = Patient.find_or_initialize_by(ci: ci)
        new_patient.assign_attributes(attrs)
        new_patient.save! if new_patient.changed?
        old_to_new[old.id] = new_patient.id
        imported += 1
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
        puts "  WARN: Patient CI=#{ci} (#{old.name}) — #{e.message}"
        skipped += 1
      end
    end

    puts "  Patients imported: #{imported}, skipped: #{skipped}"
    $patient_id_map = old_to_new
  end

  def import_emergencies!(admin)
    created = 0
    skipped = 0

    LegacyPatient.find_each do |old|
      new_patient_id = $patient_id_map[old.id]
      unless new_patient_id
        skipped += 1
        next
      end

      ingress = parse_ingress_date(old.ingress_date)
      egress = old.medical_exit.present? && old.medical_exit != '\\N' ? old.updated_at : nil
      status = old.status.presence&.to_i || 1

      begin
        Emergency.create!(
          patient_id: new_patient_id,
          ingress_date: ingress,
          status: status,
          medical_exit: old.medical_exit.presence,
          diagnostic: old.current_diagnostic.presence,
          treatment: old.treatment.presence,
          observations: old.observations.presence,
          transfer: old.transfer.presence,
          egress_at: egress,
          created_by_id: admin&.id,
          created_at: old.created_at,
          updated_at: old.updated_at
        )
        created += 1
      rescue => e
        puts "  WARN: Emergency for patient #{old.id} (#{old.name}) — #{e.message}"
        skipped += 1
      end
    end

    puts "  Emergencies created: #{created}, skipped: #{skipped}"
  end

  def import_emergency_doctors!
    created = 0
    skipped = 0

    doctor_cache = Doctor.all.index_by { |d| d.name.upcase.strip }

    Emergency.includes(:patient).find_each do |emergency|
      old_id = $patient_id_map.key(emergency.patient_id)
      next unless old_id

      old_patient = LegacyPatient.find_by(id: old_id)
      next unless old_patient

      doctor_name = old_patient.current_doctor.presence
      next unless doctor_name

      cleaned = clean_doctor_name(doctor_name)
      doctor = doctor_cache[cleaned.upcase.strip]

      unless doctor
        puts "  WARN: Doctor '#{cleaned}' not found for emergency ##{emergency.id}"
        skipped += 1
        next
      end

      begin
        EmergencyDoctor.find_or_create_by!(
          emergency_id: emergency.id,
          doctor_id: doctor.id
        ) do |ed|
          ed.primary = true
        end
        created += 1
      rescue => e
        puts "  WARN: EmergencyDoctor for emergency ##{emergency.id} — #{e.message}"
        skipped += 1
      end
    end

    puts "  EmergencyDoctors created: #{created}, skipped: #{skipped}"
  end

  def import_notes!
    created = 0
    skipped = 0

    LegacyNote.find_each do |old_note|
      new_patient_id = $patient_id_map[old_note.patient_id]
      unless new_patient_id
        skipped += 1
        next
      end

      begin
        Note.create!(
          patient_id: new_patient_id,
          note: old_note.note,
          created_by_id: nil,
          created_at: old_note.created_at,
          updated_at: old_note.updated_at
        )
        created += 1
      rescue => e
        puts "  WARN: Note ##{old_note.id} — #{e.message}"
        skipped += 1
      end
    end

    puts "  Notes imported: #{created}, skipped: #{skipped}"
  end

  # ── Utility methods ──

  def clean_doctor_name(name)
    name = name.to_s.strip
    name = name.gsub(/\b(DR|DRA|DR\.|DRA\.|DR\s|DRA\s)\s*/i, '')
    name = name.gsub(/\s*\b(Medico|Médico)\s+tratante.*\z/i, '')
    name.strip
  end

  def parse_ingress_date(str)
    return nil if str.blank? || str == '\\N'
    str = str.strip
    parts = str.split(/[\/\-]/)
    return nil unless parts.length == 3
    day = parts[0].to_i
    month = parts[1].to_i
    year = parts[2].to_i
    year += 2000 if year < 100
    Date.new(year, month, day) rescue nil
  end
end
