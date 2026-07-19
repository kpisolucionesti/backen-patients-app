namespace :migrate do
  desc "Migrate production data from SQL dump (patient_db-20260715.sql) to current schema"
  task :production_data, [:sql_path] => :environment do |_t, args|
    sql_path = args[:sql_path] || Rails.root.join('patient_db-20260715.sql')

    unless File.exist?(sql_path)
      puts "ERROR: File not found at #{sql_path}"
      puts "Usage: rails migrate:production_data[/path/to/dump.sql]"
      exit 1
    end

    content = File.read(sql_path, encoding: 'UTF-8')

    @warnings = []
    @errors = []
    @patient_id_map = {}

    puts "\n=== Starting migration from #{File.basename(sql_path)} ===\n\n"

    puts "--- Step 1: Importing Doctors ---"
    import_doctors(content)

    puts "\n--- Step 2: Importing Patients, Emergencies & EmergencyDoctors ---"
    import_patients_with_emergencies(content)

    puts "\n--- Step 3: Importing Notes ---"
    import_notes(content)

    puts "\n--- Step 4: Importing Rooms ---"
    import_rooms(content)

    puts "\n--- Step 5: Validation ---"
    validate_migration

    if @warnings.any?
      puts "\n=== Warnings (#{@warnings.size}) ==="
      @warnings.each { |w| puts "  WARN: #{w}" }
    end

    if @errors.any?
      puts "\n=== Errors (#{@errors.size}) ==="
      @errors.each { |e| puts "  ERROR: #{e}" }
    end

    puts "\n=== Migration completed ==="
  end
end

# ─── Helpers ──────────────────────────────────────────────────────────────────

def parse_copy_data(content, table_name, expected_columns)
  header = content.match(/COPY public\.#{table_name} \((.*?)\) FROM stdin;/m)
  return nil unless header

  columns = header[1].split(", ").map(&:strip)
  unless columns == expected_columns
    @errors << "Table #{table_name}: expected columns #{expected_columns.inspect}, got #{columns.inspect}"
    return nil
  end

  data_start = header.end(0) + 1
  end_marker = content.index("\n\\.\n", data_start)
  return nil unless end_marker

  raw_data = content[data_start...end_marker]
  rows = []
  raw_data.split("\n").each do |line|
    next if line.strip.empty?
    rows << parse_copy_line(line)
  end
  rows
end

def parse_copy_line(line)
  values = line.split("\t")
  values.map { |v| unescape_copy_value(v) }
end

def unescape_copy_value(value)
  return nil if value == "\\N"

  value.gsub("\\\\", "\x01").gsub("\\n", "\n").gsub("\\t", "\t")
       .gsub("\\r", "\r").gsub("\\b", "\b").gsub("\\f", "\f")
       .tr("\x01", "\\")
end

def ci_for_display(ci)
  ci.to_s.strip.empty? ? "(sin CI)" : ci.to_s.strip
end

# ─── Doctors ──────────────────────────────────────────────────────────────────

def find_or_create_specialty(name)
  Specialty.find_or_create_by!(name: name.upcase.strip) do |s|
    s.description = "Especialidad de #{name.downcase.strip}"
  end
end

def import_doctors(content)
  cols = %w[id name speciality created_at updated_at]
  rows = parse_copy_data(content, "doctors", cols)
  unless rows
    puts "  No doctors section found in dump!"
    return
  end

  puts "  Found #{rows.size} doctors in dump"

  imported = 0
  rows.each do |row|
    _old_id, name, speciality, created_at, updated_at = row
    specialty = find_or_create_specialty(speciality || 'GENERAL')
    Doctor.create!(
      name: name.strip,
      specialty: specialty,
      status: "active",
      created_at: created_at,
      updated_at: updated_at
    )
    imported += 1
  rescue ActiveRecord::RecordInvalid => e
    @errors << "Doctor '#{name}': #{e.message}"
  end

  unless Doctor.find_by(name: "YASMIN ALFONZO")
    specialty = find_or_create_specialty('GASTROENTEROLOGIA')
    Doctor.create!(
      name: "YASMIN ALFONZO",
      specialty: specialty,
      status: "active"
    )
    imported += 1
    puts "  Created missing doctor: YASMIN ALFONZO (GASTROENTEROLOGIA)"
  end

  puts "  #{imported} doctors imported (#{Doctor.count} total)"
end

# ─── Patients + Emergencies + EmergencyDoctors ────────────────────────────────

def import_patients_with_emergencies(content)
  cols = %w[id ci name age gender created_at updated_at medical_exit ingress_date
            status current_diagnostic treatment current_doctor observations transfer]
  rows = parse_copy_data(content, "patients", cols)
  unless rows
    puts "  No patients section found in dump!"
    return
  end

  puts "  Found #{rows.size} patients in dump"

  ci_counter = Hash.new(0)
  seen_cis = Set.new
  imported_patients = 0
  imported_emergencies = 0
  imported_doctor_links = 0
  batch_warnings = []

  rows.each_with_index do |row, idx|
    old_id, ci, name, age, gender, created_at, updated_at, medical_exit,
      ingress_date, status_val, current_diagnostic, treatment,
      current_doctor, observations, transfer = row

    patient_name = name.to_s.strip
    parts = patient_name.split(/\s+/)
    firstname = parts[0].to_s
    lastname = parts[1..].join(" ").to_s

    raw_ci = ci.to_s.strip

    if raw_ci.empty?
      batch_warnings << "Row #{idx}: empty CI, skipping"
      next
    end

    if seen_cis.include?(raw_ci)
      ci_counter[raw_ci] += 1
      unique_ci = "#{raw_ci}-#{ci_counter[raw_ci]}"
      batch_warnings << "Duplicate CI '#{raw_ci}' -> '#{unique_ci}' (patient: #{patient_name})"
    else
      ci_counter[raw_ci] = 1
      unique_ci = raw_ci
      seen_cis.add(raw_ci)
    end

    Patient.create!(
      ci: unique_ci,
      name: firstname,
      lastname: lastname,
      gender: gender&.strip,
      created_at: created_at,
      updated_at: updated_at
    )
    new_patient = Patient.last
    @patient_id_map[old_id] = new_patient.id
    imported_patients += 1

    emergency_status = case status_val&.to_s
                       when "2" then Emergency::STATUS_ALTA
                       when "3" then Emergency::STATUS_INGRESADO
                       else Emergency::STATUS_ATENDIDO
                       end

    Emergency.create!(
      patient_id: new_patient.id,
      ingress_date: ingress_date&.strip,
      status: emergency_status,
      medical_exit: medical_exit&.strip,
      diagnostic: current_diagnostic&.strip,
      treatment: treatment&.strip,
      observations: observations&.strip,
      transfer: transfer&.strip,
      created_at: created_at,
      updated_at: updated_at
    )
    new_emergency = Emergency.last
    imported_emergencies += 1

    if current_doctor.present?
      doc_name = current_doctor.strip
      doctor = Doctor.find_by("UPPER(name) = ?", doc_name.upcase)
      unless doctor
        specialty = find_or_create_specialty('NO ESPECIFICADA')
        doctor = Doctor.create!(
          name: doc_name,
          specialty: specialty,
          status: "active"
        )
        batch_warnings << "Created missing doctor '#{doc_name}' (referenced by patient #{patient_name})"
      end

      EmergencyDoctor.create!(
        emergency_id: new_emergency.id,
        doctor_id: doctor.id,
        primary: true
      )
      imported_doctor_links += 1
    end

    print "." if (idx + 1) % 200 == 0
  end

  puts "\n  #{imported_patients} patients imported"
  puts "  #{imported_emergencies} emergencies created"
  puts "  #{imported_doctor_links} emergency_doctor links created"

  batch_warnings.each { |w| @warnings << w }
end

# ─── Notes ────────────────────────────────────────────────────────────────────

def import_notes(content)
  cols = %w[id created_at updated_at note patient_id]
  rows = parse_copy_data(content, "notes", cols)
  unless rows
    puts "  No notes section found in dump!"
    return
  end

  puts "  Found #{rows.size} notes in dump"

  imported = 0
  skipped = 0
  rows.each_with_index do |row, idx|
    _old_id, created_at, updated_at, note, old_patient_id = row

    new_patient_id = @patient_id_map[old_patient_id]
    unless new_patient_id
      @warnings << "Note #{idx}: patient_id #{old_patient_id} not found in migrated patients, skipping"
      skipped += 1
      next
    end

    Note.create!(
      patient_id: new_patient_id,
      note: note,
      created_at: created_at,
      updated_at: updated_at
    )
    imported += 1
  end

  puts "  #{imported} notes imported (#{skipped} skipped)"
end

# ─── Rooms ────────────────────────────────────────────────────────────────────

def import_rooms(content)
  cols = %w[id room_type name created_at updated_at patient_id]
  rows = parse_copy_data(content, "rooms", cols)
  unless rows
    puts "  No rooms section found in dump!"
    return
  end

  puts "  Found #{rows.size} rooms in dump"

  imported = 0
  rows.each do |row|
    _old_id, room_type, name, created_at, updated_at, old_patient_id = row

    new_patient_id = old_patient_id ? @patient_id_map[old_patient_id] : nil

    Room.create!(
      room_type: room_type&.strip,
      name: name&.strip,
      patient_id: new_patient_id,
      created_at: created_at,
      updated_at: updated_at
    )
    imported += 1
  end

  puts "  #{imported} rooms imported"
end

# ─── Validation ───────────────────────────────────────────────────────────────

def validate_migration
  expected_patients = 2920
  expected_doctors = 39
  expected_emergencies = 2920
  expected_notes = 77
  expected_rooms = 17

  results = [
    ["Doctors",     Doctor.count,     expected_doctors],
    ["Patients",    Patient.count,    expected_patients],
    ["Emergencies", Emergency.count,  expected_emergencies],
    ["Notes",       Note.count,       expected_notes],
    ["Rooms",       Room.count,       expected_rooms],
  ]

  puts "  #{'Model'.ljust(16)} #{'Got'.rjust(6)} #{'Expected'.rjust(8)} #{'Status'}"
  puts "  #{'-' * 40}"
  all_ok = true

  results.each do |model, got, expected|
    ok = got == expected
    status = ok ? "✓ OK" : "✗ MISMATCH"
    all_ok = false unless ok
    puts "  #{model.ljust(16)} #{got.to_s.rjust(6)} #{expected.to_s.rjust(8)}   #{status}"
  end

  unless all_ok
    @warnings << "Some counts do not match expected values (see above)"
  end

  ci_dups = Patient.group(:ci).having("count(*) > 1").count
  if ci_dups.any?
    @errors << "#{ci_dups.size} CI values are still duplicated after migration!"
  else
    puts "  #{'CI Uniqueness'.ljust(16)} #{'OK'.rjust(6)} #{''.rjust(8)}   ✓ All unique"
  end

  orphan_emergencies = Emergency.where.missing(:patient)
  if orphan_emergencies.any?
    @errors << "#{orphan_emergencies.size} emergencies have no patient!"
  end

  orphan_notes = Note.where.missing(:patient)
  if orphan_notes.any?
    @errors << "#{orphan_notes.size} notes have no patient!"
  end
end
