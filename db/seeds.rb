admin_permissions = [
  'emergencia.view', 'emergencia.create', 'emergencia.edit',
  'emergencia.anular', 'emergencia.triage', 'emergencia.discharge',
  'emergencia.assign_room', 'emergencia.cargar_laboratorios',
  'emergencia.modificar_antecedentes',
  'historial.view', 'historial.export',
  'configuraciones.view',
  'pacientes.view', 'pacientes.edit',
  'pacientes.cargar_laboratorios', 'pacientes.modificar_antecedentes',
  'medicos.view', 'medicos.create', 'medicos.edit', 'medicos.suspend',
  'usuarios.view', 'usuarios.create', 'usuarios.edit',
  'usuarios.suspend', 'usuarios.manage_permissions', 'usuarios.change_password',
  'perfiles.view', 'perfiles.create', 'perfiles.edit', 'perfiles.delete',
  'rooms.view',
  'notes.view', 'notes.create', 'notes.edit', 'notes.delete',
  'especialidades.view', 'especialidades.create', 'especialidades.edit', 'especialidades.delete',
  'agenda.edit',
  'citas.view', 'citas.create', 'citas.edit', 'citas.delete', 'citas.attend',
  'quirofano.view', 'quirofano.edit',
]

Profile.find_or_create_by(name: 'Administrador') do |p|
  p.description = 'Acceso completo a todos los modulos'
  p.permissions = admin_permissions + ['areas.view', 'areas.create', 'areas.edit', 'areas.delete', 'rooms.create', 'rooms.edit', 'rooms.delete']
end

Profile.find_or_create_by(name: 'User') do |p|
  p.description = 'Acceso basico a visualizar emergencias e historial'
  p.permissions = ['emergencia.view', 'emergencia.create', 'emergencia.assign_room', 'historial.view', 'pacientes.view', 'pacientes.edit']
end

admin_user = User.find_or_initialize_by(email: 'admin@emerboard.com')
admin_user.assign_attributes(
  username: 'admin',
  password: 'Admin123456!',
  password_confirmation: 'Admin123456!',
  name: 'Admin',
  profile: Profile.find_by(name: 'Administrador'),
  status: 'active',
  confirmed_at: Time.current
)
admin_user.save!

ClinicalStudyClassification.find_or_create_by(key: 'laboratorios') do |c|
  c.name = 'Laboratorios'
  c.color = '#1565c0'
  c.sort_order = 10
end
ClinicalStudyClassification.find_or_create_by(key: 'imagenologia') do |c|
  c.name = 'Imagenologia'
  c.color = '#7b1fa2'
  c.sort_order = 11
end
ClinicalStudyClassification.find_or_create_by(key: 'banco_sangre') do |c|
  c.name = 'Banco de Sangre'
  c.color = '#c62828'
  c.sort_order = 12
end

# ═══════════════════════════════════════════════════════════════
# Personal Clinico
# ═══════════════════════════════════════════════════════════════

puts "\n>> Sembrando Personal Clinico..."
specialties = {}
[
  'MEDICINA INTERNA', 'CARDIOLOGIA', 'CIRUGIA GENERAL', 'TRAUMATOLOGIA',
  'GINECOLOGIA', 'PEDIATRIA', 'NEUROCIRUGIA', 'UROLOGIA', 'OFTALMOLOGIA',
  'GASTROENTEROLOGIA', 'NEUMONOLOGIA', 'INTENSIVISTA'
].each do |name|
  specialties[name] = Specialty.find_or_create_by(name: name) do |s|
    s.description = "Especialidad de #{name.downcase}"
  end
end

doctors = [
  { name: 'Dr. Carlos Mendoza',    specialty: 'MEDICINA INTERNA', email: 'cmendoza@hospital.com', phone: '+58 412 1111111' },
  { name: 'Dra. Maria Garcia',     specialty: 'CARDIOLOGIA',      email: 'mgarcia@hospital.com',  phone: '+58 412 2222222' },
  { name: 'Dr. Jose Perez',        specialty: 'CIRUGIA GENERAL',  email: 'jperez@hospital.com',   phone: '+58 412 3333333' },
  { name: 'Dra. Ana Rodriguez',    specialty: 'TRAUMATOLOGIA',    email: 'arodriguez@hospital.com', phone: '+58 412 4444444' },
  { name: 'Dr. Luis Fernandez',    specialty: 'GINECOLOGIA',      email: 'lfernandez@hospital.com', phone: '+58 412 5555555' },
  { name: 'Dra. Carmen Silva',     specialty: 'PEDIATRIA',        email: 'csilva@hospital.com',   phone: '+58 412 6666666' },
  { name: 'Dr. Rafael Torres',     specialty: 'NEUROCIRUGIA',     email: 'rtorres@hospital.com',  phone: '+58 412 7777777' },
  { name: 'Dra. Patricia Herrera', specialty: 'UROLOGIA',         email: 'pherrera@hospital.com', phone: '+58 412 8888888' },
  { name: 'Dr. Miguel Vargas',     specialty: 'OFTALMOLOGIA',     email: 'mvargas@hospital.com',  phone: '+58 412 9999999' },
  { name: 'Dra. Sofia Morales',    specialty: 'GASTROENTEROLOGIA', email: 'smorales@hospital.com', phone: '+58 414 0000001' },
  { name: 'Dr. Andres Castillo',   specialty: 'NEUMONOLOGIA',     email: 'acastillo@hospital.com', phone: '+58 414 0000002' },
  { name: 'Dra. Gabriela Rojas',   specialty: 'INTENSIVISTA',     email: 'grojas@hospital.com',   phone: '+58 414 0000003' },
  { name: 'Dr. Fernando Gomez',    specialty: 'MEDICINA INTERNA', email: 'fgomez@hospital.com',   phone: '+58 414 0000004' },
  { name: 'Dra. Laura Diaz',       specialty: 'CARDIOLOGIA',      email: 'ldiaz@hospital.com',    phone: '+58 414 0000005' },
  { name: 'Dr. Hector Nunez',      specialty: 'CIRUGIA GENERAL',  email: 'hnunez@hospital.com',   phone: '+58 414 0000006' },
]

doctors.each do |doc|
  Doctor.find_or_create_by(name: doc[:name]) do |d|
    d.specialty = specialties[doc[:specialty]]
    d.email = doc[:email]
    d.phone = doc[:phone]
    d.status = 'active'
  end
end

# Horarios de consulta (Lunes y Miercoles para cada medico activo)
puts ">> Sembrando horarios medicos..."
Doctor.active.each do |d|
  DoctorSchedule.find_or_create_by(doctor: d, day_of_week: 1) do |s|
    s.start_time = '08:00'; s.end_time = '12:00'
    s.appointment_duration = 30; s.appointment_mode = 'scheduled'
  end
  DoctorSchedule.find_or_create_by(doctor: d, day_of_week: 3) do |s|
    s.start_time = '14:00'; s.end_time = '18:00'
    s.appointment_duration = 30; s.appointment_mode = 'scheduled'
  end
end

# ═══════════════════════════════════════════════════════════════
# Infraestructura
# ═══════════════════════════════════════════════════════════════

puts "\n>> Sembrando infraestructura..."

areas = {}
[
  { name: 'Emergencia Adultos', room_type: 'adulto', description: 'Area de emergencia para pacientes adultos' },
  { name: 'Emergencia Pediatría', room_type: 'pediatria', description: 'Area de emergencia para pacientes pediatricos' },
  { name: 'Quirófano Principal', room_type: 'quirofano', description: 'Quirófanos de cirugía programada y emergencia' },
  { name: 'Hospitalización General', room_type: 'hospitalizacion', description: 'Area de hospitalizacion general' },
  { name: 'UCI', room_type: 'uci', description: 'Unidad de Cuidados Intensivos' },
].each do |a|
  areas[a[:name]] = Area.find_or_create_by(name: a[:name]) do |area|
    area.room_type = a[:room_type]
    area.description = a[:description]
  end
end

room_config = {
  'Emergencia Adultos'    => ['Cubiculo 1', 'Cubiculo 2', 'Cubiculo 3', 'Cubiculo 4', 'Cubiculo 5', 'Traumashock', 'Consultorio'],
  'Emergencia Pediatría'  => ['Cubiculo 1', 'Cubiculo 2', 'Consultorio', 'Traumashock'],
  'Quirófano Principal'   => ['Quirofano 1', 'Quirofano 2', 'Quirofano 3'],
  'Hospitalización General' => ['Habitacion 101', 'Habitacion 102', 'Habitacion 103', 'Habitacion 104', 'Habitacion 105'],
  'UCI'                    => ['Cama UCI 1', 'Cama UCI 2', 'Cama UCI 3', 'Cama UCI 4'],
}

room_config.each do |area_name, rooms|
  rooms.each do |room_name|
    Room.find_or_create_by(name: room_name) { |r| r.area = areas[area_name] }
  end
end

# ═══════════════════════════════════════════════════════════════
# Catalogos Clinicos (Estudios Clinicos)
# ═══════════════════════════════════════════════════════════════

puts "\n>> Sembrando catalogos clinicos..."

lab_class = ClinicalStudyClassification.find_by(key: 'laboratorios')
img_class = ClinicalStudyClassification.find_by(key: 'imagenologia')

groups = {
  'Hematologia' => LabParameterGroup.find_or_create_by(name: 'Hematologia'),
  'Quimica Sanguinea' => LabParameterGroup.find_or_create_by(name: 'Quimica Sanguinea'),
  'Inmunologia' => LabParameterGroup.find_or_create_by(name: 'Inmunologia'),
  'Uroanalisis' => LabParameterGroup.find_or_create_by(name: 'Uroanalisis'),
  'Coagulacion' => LabParameterGroup.find_or_create_by(name: 'Coagulacion'),
  'Electrolitos' => LabParameterGroup.find_or_create_by(name: 'Electrolitos'),
}

lab_params = [
  { name: 'Hemoglobina',         abbr: 'Hb',     unit: 'g/dL',     group: 'Hematologia',        male: '13-17',    female: '12-16' },
  { name: 'Hematocrito',         abbr: 'Hto',    unit: '%',        group: 'Hematologia',        male: '40-52',    female: '36-48' },
  { name: 'Leucocitos',          abbr: 'WBC',    unit: 'x10³/µL',  group: 'Hematologia',        male: '4.5-11',   female: '4.5-11' },
  { name: 'Plaquetas',           abbr: 'PLT',    unit: 'x10³/µL',  group: 'Hematologia',        male: '150-450',  female: '150-450' },
  { name: 'Glucosa',             abbr: 'GLU',    unit: 'mg/dL',    group: 'Quimica Sanguinea',  male: '70-110',   female: '70-110' },
  { name: 'Creatinina',          abbr: 'CREA',   unit: 'mg/dL',    group: 'Quimica Sanguinea',  male: '0.6-1.3',  female: '0.5-1.1' },
  { name: 'Urea',                abbr: 'UREA',   unit: 'mg/dL',    group: 'Quimica Sanguinea',  male: '15-45',    female: '15-45' },
  { name: 'TGO/AST',             abbr: 'TGO',    unit: 'U/L',      group: 'Quimica Sanguinea',  male: '10-40',    female: '10-35' },
  { name: 'TGP/ALT',             abbr: 'TGP',    unit: 'U/L',      group: 'Quimica Sanguinea',  male: '10-40',   female: '7-35' },
  { name: 'Proteína C Reactiva', abbr: 'PCR',    unit: 'mg/L',     group: 'Inmunologia',        male: '<5',      female: '<5' },
  { name: 'TSH',                 abbr: 'TSH',    unit: 'mIU/L',    group: 'Inmunologia',        male: '0.4-4.0', female: '0.4-4.0' },
  { name: 'Densidad Urinaria',    abbr: 'DU',     unit: '',         group: 'Uroanalisis',         male: '1.005-1.030',  female: '1.005-1.030' },
  { name: 'TP',                  abbr: 'TP',     unit: 'seg',      group: 'Coagulacion',         male: '11-13.5', female: '11-13.5' },
  { name: 'TPT',                 abbr: 'TPT',    unit: 'seg',      group: 'Coagulacion',         male: '25-35',  female: '25-35' },
  { name: 'Sodio (Na+)',         abbr: 'Na+',    unit: 'mEq/L',    group: 'Electrolitos',        male: '135-145', female: '135-145' },
  { name: 'Potasio (K+)',        abbr: 'K+',     unit: 'mEq/L',    group: 'Electrolitos',        male: '3.5-5.0', female: '3.5-5.0' },
]

lab_params.each do |p|
  ranges = if p[:male].start_with?('<')
    { male: { type: 'inequality', comparator: '<', value: p[:male].gsub('<', '').to_f },
      female: { type: 'inequality', comparator: '<', value: p[:female].gsub('<', '').to_f } }
  else
    male_min, male_max = p[:male].split('-').map(&:to_f)
    female_min, female_max = p[:female].split('-').map(&:to_f)
    { male: { type: 'range', min: male_min, max: male_max }, female: { type: 'range', min: female_min, max: female_max } }
  end

  LabParameter.find_or_create_by(name: p[:name]) do |lp|
    lp.lab_parameter_group = groups[p[:group]]
    lp.clinical_study_classification = lab_class
    lp.abbreviation = p[:abbr]
    lp.unit = p[:unit]
    lp.reference_ranges = ranges
  end
end

# ── Imagenología ──
img_group = LabParameterGroup.find_or_create_by(name: 'Imagenologia')
img_params = [
  { name: 'Radiografía de Tórax (PA y Lateral)',     abbr: 'RxT',    unit: '' },
  { name: 'Radiografía de Tórax (AP Portátil)',       abbr: 'RxTAp',  unit: '' },
  { name: 'Radiografía de Abdomen Simple',             abbr: 'RxAbd',  unit: '' },
  { name: 'Radiografía de Abdomen (Decúbito)',         abbr: 'RxAbdD', unit: '' },
  { name: 'Radiografía de Cráneo (AP y Lateral)',      abbr: 'RxC',    unit: '' },
  { name: 'Radiografía de Cráneo (Towne)',             abbr: 'RxCTow', unit: '' },
  { name: 'Radiografía de Columna Cervical',            abbr: 'RxColC', unit: '' },
  { name: 'Radiografía de Columna Dorsal',              abbr: 'RxColD', unit: '' },
  { name: 'Radiografía de Columna Lumbar',              abbr: 'RxColL', unit: '' },
  { name: 'Radiografía de Columna Lumbosacra',          abbr: 'RxColLS', unit: '' },
  { name: 'Radiografía de Hombro',                      abbr: 'RxHom',  unit: '' },
  { name: 'Radiografía de Codo',                        abbr: 'RxCodo', unit: '' },
  { name: 'Radiografía de Muñeca',                      abbr: 'RxMun',  unit: '' },
  { name: 'Radiografía de Mano',                        abbr: 'RxMan',  unit: '' },
  { name: 'Radiografía de Cadera',                      abbr: 'RxCad',  unit: '' },
  { name: 'Radiografía de Rodilla',                     abbr: 'RxRod',  unit: '' },
  { name: 'Radiografía de Tobillo',                     abbr: 'RxTob',  unit: '' },
  { name: 'Radiografía de Pie',                         abbr: 'RxPie',  unit: '' },
  { name: 'Radiografía de Senos Paranasales',           abbr: 'RxSPN',  unit: '' },
  { name: 'Radiografía de Maxilar Inferior',            abbr: 'RxMand', unit: '' },
  { name: 'Tomografía de Cráneo Simple',                abbr: 'TCS',    unit: '' },
  { name: 'Tomografía de Cráneo Contrastada',           abbr: 'TCC',    unit: '' },
  { name: 'Tomografía de Tórax Simple',                 abbr: 'TTS',    unit: '' },
  { name: 'Tomografía de Tórax Contrastada',            abbr: 'TTC',    unit: '' },
  { name: 'Tomografía de Abdomen Simple',               abbr: 'TAS',    unit: '' },
  { name: 'Tomografía de Abdomen Contrastada',          abbr: 'TAC',    unit: '' },
  { name: 'Tomografía de Columna Cervical',             abbr: 'TCColC', unit: '' },
  { name: 'Tomografía de Columna Lumbar',               abbr: 'TCColL', unit: '' },
  { name: 'Tomografía de Senos Paranasales',            abbr: 'TCSPN',  unit: '' },
  { name: 'Tomografía de Pelvis',                       abbr: 'TCPel',  unit: '' },
  { name: 'Angio-TC de Tórax',                          abbr: 'AngTC',  unit: '' },
  { name: 'Angio-TC Cerebral',                          abbr: 'AngTCC', unit: '' },
  { name: 'Ecografía Abdominal Superior',               abbr: 'EcoAbS', unit: '' },
  { name: 'Ecografía Abdominal Total',                  abbr: 'EcoAbT', unit: '' },
  { name: 'Ecografía Renal y Vía Urinaria',             abbr: 'EcoRen', unit: '' },
  { name: 'Ecografía Renal con Doppler',                abbr: 'EcoRenD', unit: '' },
  { name: 'Ecografía Pélvica (Transabdominal)',         abbr: 'EcoPelT', unit: '' },
  { name: 'Ecografía Pélvica (Transvaginal)',           abbr: 'EcoPelV', unit: '' },
  { name: 'Ecografía Obstétrica (1er Trimestre)',       abbr: 'EcoObs1', unit: '' },
  { name: 'Ecografía Obstétrica (2do Trimestre)',       abbr: 'EcoObs2', unit: '' },
  { name: 'Ecografía Obstétrica (3er Trimestre)',       abbr: 'EcoObs3', unit: '' },
  { name: 'Ecografía Obstétrica (Doppler Fetal)',       abbr: 'EcoObsD', unit: '' },
  { name: 'Ecografía de Partes Blandas',                abbr: 'EcoPB',   unit: '' },
  { name: 'Ecografía de Cuello / Tiroides',             abbr: 'EcoCue',  unit: '' },
  { name: 'Ecografía de Mama',                          abbr: 'EcoMama', unit: '' },
  { name: 'Ecografía Musculoesquelética',               abbr: 'EcoMSK',  unit: '' },
  { name: 'Ecografía Hepática y Vía Biliar',            abbr: 'EcoHep',  unit: '' },
  { name: 'Ecografía de Próstata (Transrectal)',        abbr: 'EcoPros', unit: '' },
  { name: 'Ecografía Doppler Venoso de Miembros Inferiores', abbr: 'EcoDVI', unit: '' },
  { name: 'Ecografía Doppler Arterial de Miembros Inferiores', abbr: 'EcoDAI', unit: '' },
  { name: 'Resonancia Magnética Craneal',                abbr: 'RMCr',   unit: '' },
  { name: 'Resonancia Magnética de Columna Cervical',   abbr: 'RMColC', unit: '' },
  { name: 'Resonancia Magnética de Columna Lumbar',     abbr: 'RMColL', unit: '' },
  { name: 'Resonancia Magnética de Abdomen',            abbr: 'RMAbd',  unit: '' },
  { name: 'Resonancia Magnética de Rodilla',            abbr: 'RMRod',  unit: '' },
  { name: 'Resonancia Magnética de Hombro',             abbr: 'RMHom',  unit: '' },
  { name: 'Resonancia Magnética de Cadera',             abbr: 'RMCad',  unit: '' },
]

img_params.each do |p|
  LabParameter.find_or_create_by(name: p[:name]) do |lp|
    lp.lab_parameter_group = img_group
    lp.clinical_study_classification = img_class
    lp.abbreviation = p[:abbr]
    lp.unit = p[:unit]
  end
end

# ═══════════════════════════════════════════════════════════════
# Catalogos Clinicos
# ═══════════════════════════════════════════════════════════════

puts "\n>> Sembrando catalogos clinicos..."

# ── Vias de Administracion ──
%w[
  Oral Intravenosa Intramuscular Subcutánea
  Intradérmica Tópica Rectal Inhalatoria
  Sublingual Intratecal Intraósea Peridural
  Transdérmica Intravítrea Intraarticular
].each do |name|
  MedicationRoute.find_or_create_by(name: name)
end

# ── Presentaciones ──
%w[
  Ampolleta Comprimido Cápsula Jarabe Suspensión
  Crema Ungüento Gotas Óvulo Supositorio
  Parche Solución Inyectable Polvo Liofilizado
  Aerospray Tableta Masticable Granulado
].each do |name|
  MedicationPresentation.find_or_create_by(name: name)
end

# ── Concentraciones ──
%w[
  1mg 5mg 10mg 25mg 50mg 100mg 250mg 500mg
  750mg 1g 1.5g 2g 5g 10g 15g 30g
  1µg 5µg 10µg 15µg 25µg 50µg 100µg 200µg
  0.1% 0.5% 1% 2% 5% 10%
  1mg/mL 5mg/mL 10mg/mL 50mg/mL 100mg/mL
  100mg/5mL 250mg/5mL 500mg/5mL
  1M 2M 5M 10M 20M
].each do |name|
  MedicationConcentration.find_or_create_by(name: name)
end

# ── Medicamentos ──
medications = [
  { name: 'Paracetamol',            generic_name: 'Acetaminofén',          presentation: 'Comprimido',   concentration: '500mg',  medication_route: 'Oral' },
  { name: 'Paracetamol Infantil',   generic_name: 'Acetaminofén',          presentation: 'Jarabe',       concentration: '100mg/5mL', medication_route: 'Oral' },
  { name: 'Ibuprofeno',             generic_name: 'Ibuprofeno',            presentation: 'Comprimido',   concentration: '400mg',  medication_route: 'Oral' },
  { name: 'Ibuprofeno Infantil',    generic_name: 'Ibuprofeno',            presentation: 'Jarabe',       concentration: '100mg/5mL', medication_route: 'Oral' },
  { name: 'Amoxicilina',            generic_name: 'Amoxicilina',           presentation: 'Cápsula',      concentration: '500mg',  medication_route: 'Oral' },
  { name: 'Amoxicilina + Ác. Clavulánico', generic_name: 'Amoxicilina / Ácido Clavulánico', presentation: 'Comprimido', concentration: '875/125mg', medication_route: 'Oral' },
  { name: 'Ceftriaxona',            generic_name: 'Ceftriaxona',           presentation: 'Inyectable',   concentration: '1g',     medication_route: 'Intravenosa' },
  { name: 'Ceftriaxona IM',         generic_name: 'Ceftriaxona',           presentation: 'Inyectable',   concentration: '1g',     medication_route: 'Intramuscular' },
  { name: 'Metamizol',              generic_name: 'Dipirona Sódica',       presentation: 'Ampolleta',    concentration: '1g/2mL', medication_route: 'Intravenosa' },
  { name: 'Metamizol Oral',         generic_name: 'Dipirona Sódica',       presentation: 'Gotas',        concentration: '500mg/mL', medication_route: 'Oral' },
  { name: 'Omeprazol',              generic_name: 'Omeprazol',             presentation: 'Cápsula',      concentration: '20mg',   medication_route: 'Oral' },
  { name: 'Omeprazol IV',           generic_name: 'Omeprazol',             presentation: 'Inyectable',   concentration: '40mg',   medication_route: 'Intravenosa' },
  { name: 'Losartán',               generic_name: 'Losartán Potásico',     presentation: 'Comprimido',   concentration: '50mg',   medication_route: 'Oral' },
  { name: 'Enalapril',              generic_name: 'Enalapril Maleato',     presentation: 'Comprimido',   concentration: '10mg',   medication_route: 'Oral' },
  { name: 'Furosemida',             generic_name: 'Furosemida',            presentation: 'Comprimido',   concentration: '40mg',   medication_route: 'Oral' },
  { name: 'Furosemida IV',          generic_name: 'Furosemida',            presentation: 'Ampolleta',    concentration: '20mg/2mL', medication_route: 'Intravenosa' },
  { name: 'Enoxaparina',            generic_name: 'Enoxaparina Sódica',    presentation: 'Inyectable',   concentration: '60mg',   medication_route: 'Subcutánea' },
  { name: 'Heparina Sódica',        generic_name: 'Heparina Sódica',       presentation: 'Inyectable',   concentration: '5000 UI/mL', medication_route: 'Intravenosa' },
  { name: 'Insulina Rápida',        generic_name: 'Insulina Humana',       presentation: 'Inyectable',   concentration: '100 UI/mL', medication_route: 'Subcutánea' },
  { name: 'Insulina NPH',           generic_name: 'Insulina NPH',          presentation: 'Inyectable',   concentration: '100 UI/mL', medication_route: 'Subcutánea' },
  { name: 'Salbutamol Inhalador',   generic_name: 'Salbutamol',            presentation: 'Aerospray',    concentration: '100µg/dosis', medication_route: 'Inhalatoria' },
  { name: 'Salbutamol Nebulización', generic_name: 'Salbutamol',           presentation: 'Solución',     concentration: '5mg/mL', medication_route: 'Inhalatoria' },
  { name: 'Prednisona',             generic_name: 'Prednisona',            presentation: 'Comprimido',   concentration: '20mg',   medication_route: 'Oral' },
  { name: 'Hidrocortisona',         generic_name: 'Hidrocortisona',        presentation: 'Inyectable',   concentration: '100mg',  medication_route: 'Intravenosa' },
  { name: 'Dexametasona',           generic_name: 'Dexametasona',          presentation: 'Ampolleta',    concentration: '8mg/2mL', medication_route: 'Intravenosa' },
  { name: 'Morfina',                generic_name: 'Morfina Clorhidrato',   presentation: 'Ampolleta',    concentration: '10mg/mL', medication_route: 'Intravenosa' },
  { name: 'Tramadol',               generic_name: 'Tramadol Clorhidrato',  presentation: 'Ampolleta',    concentration: '50mg/mL', medication_route: 'Intravenosa' },
  { name: 'Diazepam',               generic_name: 'Diazepam',              presentation: 'Ampolleta',    concentration: '10mg/2mL', medication_route: 'Intravenosa' },
  { name: 'Haloperidol',            generic_name: 'Haloperidol',           presentation: 'Ampolleta',    concentration: '5mg/mL', medication_route: 'Intramuscular' },
  { name: 'Metoclopramida',         generic_name: 'Metoclopramida',        presentation: 'Ampolleta',    concentration: '10mg/2mL', medication_route: 'Intravenosa' },
]

medications.each do |m|
  Medication.find_or_create_by(name: m[:name]) do |med|
    med.generic_name = m[:generic_name]
    med.presentation = m[:presentation]
    med.concentration = m[:concentration]
    med.medication_route = m[:medication_route]
  end
end

# ── Diagnosticos CIE-10 ──
diagnoses = [
  { code: 'A00',  description: 'Cólera',                                                  category: 'Infecciosas' },
  { code: 'A09',  description: 'Diarrea y gastroenteritis presumiblemente infecciosa',     category: 'Infecciosas' },
  { code: 'A15',  description: 'Tuberculosis respiratoria',                                category: 'Infecciosas' },
  { code: 'A41',  description: 'Sepsis, no especificada',                                  category: 'Infecciosas' },
  { code: 'B34',  description: 'Enfermedad por virus, no especificada',                    category: 'Infecciosas' },
  { code: 'C16',  description: 'Tumor maligno del estómago',                               category: 'Neoplasias' },
  { code: 'C18',  description: 'Tumor maligno del colon',                                  category: 'Neoplasias' },
  { code: 'C34',  description: 'Tumor maligno de los bronquios / pulmón',                  category: 'Neoplasias' },
  { code: 'C50',  description: 'Tumor maligno de la mama',                                 category: 'Neoplasias' },
  { code: 'D64',  description: 'Anemia, no especificada',                                  category: 'Hematológicas' },
  { code: 'E10',  description: 'Diabetes mellitus tipo 1',                                 category: 'Endócrinas' },
  { code: 'E11',  description: 'Diabetes mellitus tipo 2',                                 category: 'Endócrinas' },
  { code: 'E14',  description: 'Diabetes mellitus, no especificada',                       category: 'Endócrinas' },
  { code: 'E78',  description: 'Hiperlipidemia, no especificada',                          category: 'Endócrinas' },
  { code: 'E86',  description: 'Hipovolemia / Deshidratación',                             category: 'Metabólicas' },
  { code: 'F20',  description: 'Esquizofrenia',                                            category: 'Salud Mental' },
  { code: 'F32',  description: 'Episodio depresivo mayor',                                 category: 'Salud Mental' },
  { code: 'F41',  description: 'Trastorno de ansiedad, no especificado',                   category: 'Salud Mental' },
  { code: 'G40',  description: 'Epilepsia, tipos no especificados',                        category: 'Neurológicas' },
  { code: 'G45',  description: 'Ataque isquémico transitorio (AIT)',                       category: 'Neurológicas' },
  { code: 'I10',  description: 'Hipertensión esencial (primaria)',                         category: 'Cardiovasculares' },
  { code: 'I21',  description: 'Infarto agudo al miocardio',                              category: 'Cardiovasculares' },
  { code: 'I25',  description: 'Enfermedad isquémica crónica del corazón',                 category: 'Cardiovasculares' },
  { code: 'I48',  description: 'Fibrilación y aleteo auricular',                           category: 'Cardiovasculares' },
  { code: 'I50',  description: 'Insuficiencia cardíaca',                                   category: 'Cardiovasculares' },
  { code: 'I63',  description: 'Infarto cerebral',                                         category: 'Neurológicas' },
  { code: 'J15',  description: 'Neumonía bacteriana, no clasificada en otra parte',        category: 'Respiratorias' },
  { code: 'J18',  description: 'Neumonía, organismo no especificado',                      category: 'Respiratorias' },
  { code: 'J44',  description: 'EPOC con exacerbación aguda',                              category: 'Respiratorias' },
  { code: 'J45',  description: 'Asma',                                                     category: 'Respiratorias' },
  { code: 'J96',  description: 'Insuficiencia respiratoria',                               category: 'Respiratorias' },
  { code: 'K25',  description: 'Úlcera gástrica',                                          category: 'Digestivas' },
  { code: 'K29',  description: 'Gastritis, no especificada',                               category: 'Digestivas' },
  { code: 'K35',  description: 'Apendicitis aguda',                                        category: 'Digestivas' },
  { code: 'K57',  description: 'Diverticulosis / Diverticulitis',                          category: 'Digestivas' },
  { code: 'K80',  description: 'Colelitiasis',                                             category: 'Digestivas' },
  { code: 'K85',  description: 'Pancreatitis aguda',                                       category: 'Digestivas' },
  { code: 'N10',  description: 'Nefritis tubulointersticial aguda / Pielonefritis',        category: 'Renales' },
  { code: 'N20',  description: 'Cálculo del riñón y uréter',                               category: 'Renales' },
  { code: 'N39',  description: 'Infección del tracto urinario, sitio no especificado',     category: 'Renales' },
  { code: 'N40',  description: 'Hiperplasia benigna de la próstata',                       category: 'Urológicas' },
  { code: 'R10',  description: 'Dolor abdominal',                                          category: 'Síntomas' },
  { code: 'R50',  description: 'Fiebre de origen desconocido',                             category: 'Síntomas' },
  { code: 'R55',  description: 'Síncope / Colapso',                                        category: 'Síntomas' },
  { code: 'S06',  description: 'Traumatismo intracraneal / TEC',                           category: 'Traumatismos' },
  { code: 'S22',  description: 'Fractura de costilla(s) / esternón / columna torácica',    category: 'Traumatismos' },
  { code: 'S32',  description: 'Fractura de columna lumbar / pelvis',                      category: 'Traumatismos' },
  { code: 'S42',  description: 'Fractura de hombro / brazo',                               category: 'Traumatismos' },
  { code: 'S52',  description: 'Fractura del antebrazo',                                   category: 'Traumatismos' },
  { code: 'S72',  description: 'Fractura del fémur',                                       category: 'Traumatismos' },
  { code: 'S82',  description: 'Fractura de pierna / tobillo',                             category: 'Traumatismos' },
  { code: 'T14',  description: 'Traumatismo de región corporal no especificada',           category: 'Traumatismos' },
  { code: 'Z03',  description: 'Observación por sospecha de enfermedad',                   category: 'Observación' },
]

diagnoses.each do |d|
  Diagnosis.find_or_create_by(code: d[:code]) do |diag|
    diag.description = d[:description]
    diag.category = d[:category]
  end
end

# ── Categorias de Alergias ──
%w[
  Medicamentos Alimentos Ambientales
  Insectos Látex Metales Picaduras
  Cosméticos Contraste Radiológico
].each do |name|
  AllergenCategory.find_or_create_by(name: name)
end

# ── Alergenos ──
allergens = [
  { name: 'Penicilina',            category: 'Medicamentos' },
  { name: 'Amoxicilina',           category: 'Medicamentos' },
  { name: 'Cefalosporinas',        category: 'Medicamentos' },
  { name: 'Sulfonamidas',          category: 'Medicamentos' },
  { name: 'AINEs (Ibuprofeno)',    category: 'Medicamentos' },
  { name: 'Aspirina',              category: 'Medicamentos' },
  { name: 'Paracetamol',           category: 'Medicamentos' },
  { name: 'Morfina',               category: 'Medicamentos' },
  { name: 'Lidocaína',             category: 'Medicamentos' },
  { name: 'Contraste Yodado',      category: 'Contraste Radiológico' },
  { name: 'Gadolinio',             category: 'Contraste Radiológico' },
  { name: 'Mariscos',              category: 'Alimentos' },
  { name: 'Cacahuate / Maní',      category: 'Alimentos' },
  { name: 'Nueces',                category: 'Alimentos' },
  { name: 'Huevo',                 category: 'Alimentos' },
  { name: 'Leche',                 category: 'Alimentos' },
  { name: 'Soja',                  category: 'Alimentos' },
  { name: 'Trigo / Gluten',        category: 'Alimentos' },
  { name: 'Polen',                 category: 'Ambientales' },
  { name: 'Ácaros',                category: 'Ambientales' },
  { name: 'Mohos',                 category: 'Ambientales' },
  { name: 'Caspa de Mascotas',     category: 'Ambientales' },
  { name: 'Látex',                 category: 'Látex' },
  { name: 'Níquel',                category: 'Metales' },
  { name: 'Picadura de Abeja',     category: 'Picaduras' },
  { name: 'Picadura de Avispa',    category: 'Picaduras' },
  { name: 'Picadura de Mosquito',  category: 'Picaduras' },
  { name: 'Fragancias',            category: 'Cosméticos' },
]

allergens.each do |a|
  Allergen.find_or_create_by(name: a[:name]) do |al|
    al.category = a[:category]
  end
end

# ── Categorias de Cirugia ──
%w[
  Cirugía General Cirugía Cardiovascular
  Cirugía Torácica Neurocirugía
  Cirugía Ortopédica Cirugía Plástica
  Cirugía Ginecológica Cirugía Urológica
  Cirugía Oftalmológica Cirugía Otorrinolaringológica
  Cirugía Pediátrica Cirugía Maxilofacial
  Cirugía Vascular Cirugía Endoscópica / Laparoscópica
  Cirugía Oncológica Trasplantes
].each do |name|
  SurgeryCategory.find_or_create_by(name: name)
end

# ── Procedimientos Quirúrgicos ──
procedures = [
  { code: 'APX',   name: 'Apendicectomía',                                    category: 'Cirugía General' },
  { code: 'COL',   name: 'Colecistectomía Laparoscópica',                     category: 'Cirugía General' },
  { code: 'HERN',  name: 'Hernioplastía Inguinal',                            category: 'Cirugía General' },
  { code: 'HEM',   name: 'Hemorroidectomía',                                  category: 'Cirugía General' },
  { code: 'LAP',   name: 'Laparotomía Exploradora',                           category: 'Cirugía General' },
  { code: 'CRV',   name: 'Revascularización Coronaria (CABG)',                category: 'Cirugía Cardiovascular' },
  { code: 'CATH',  name: 'Cateterismo Cardíaco',                              category: 'Cirugía Cardiovascular' },
  { code: 'TVQ',   name: 'Toracotomía / Videotoracoscopia (VATS)',            category: 'Cirugía Torácica' },
  { code: 'DRE',   name: 'Drenaje Pleural / Tubo de Torax',                   category: 'Cirugía Torácica' },
  { code: 'CRM',   name: 'Craneotomía',
category: 'Neurocirugía' },
  { code: 'DVP',   name: 'Derivación Ventrículo-Peritoneal (DVP)',            category: 'Neurocirugía' },
  { code: 'LAM',   name: 'Laminectomía / Discectomía',                        category: 'Neurocirugía' },
  { code: 'FXF',   name: 'Fijación de Fractura (ORIF)',                       category: 'Cirugía Ortopédica' },
  { code: 'PTC',   name: 'Prótesis Total de Cadera',                          category: 'Cirugía Ortopédica' },
  { code: 'PTR',   name: 'Prótesis Total de Rodilla',                         category: 'Cirugía Ortopédica' },
  { code: 'ART',   name: 'Artroscopía',                                       category: 'Cirugía Ortopédica' },
  { code: 'CES',   name: 'Cesárea',                                           category: 'Cirugía Ginecológica' },
  { code: 'HTR',   name: 'Histerectomía',                                     category: 'Cirugía Ginecológica' },
  { code: 'OOF',   name: 'Ooforectomía / Salpingooforectomía',                category: 'Cirugía Ginecológica' },
  { code: 'RTP',   name: 'Resección Transuretral de Próstata (RTUP)',         category: 'Cirugía Urológica' },
  { code: 'NFR',   name: 'Nefrectomía',                                       category: 'Cirugía Urológica' },
  { code: 'LIT',   name: 'Litotricia / Ureteroscopía',                        category: 'Cirugía Urológica' },
  { code: 'FACO',  name: 'Facomulsificación / Cataratas',                     category: 'Cirugía Oftalmológica' },
  { code: 'TRAQ',  name: 'Traqueostomía',                                     category: 'Cirugía Otorrinolaringológica' },
  { code: 'AMG',   name: 'Amigdalectomía',                                    category: 'Cirugía Otorrinolaringológica' },
  { code: 'PLA',   name: 'Reducción Abierta / Fijación Interna (Maxilofacial)', category: 'Cirugía Maxilofacial' },
  { code: 'BYP',   name: 'By-pass Vascular / Fístula AV',                     category: 'Cirugía Vascular' },
  { code: 'LAPC',  name: 'Laparoscopía Diagnóstica / Terapéutica',           category: 'Cirugía Endoscópica / Laparoscópica' },
]

procedures.each do |p|
  SurgeryProcedure.find_or_create_by(name: p[:name]) do |sp|
    sp.code = p[:code]
    sp.category = p[:category]
  end
end

# ── Tipos de Anestesia ──
%w[
  Anestesia General Balanceada
  Anestesia General Endovenosa Total (TIVA)
  Anestesia Regional (Raquídea / Espinal)
  Anestesia Peridural (Epidural)
  Bloqueo de Plexo Braquial
  Bloqueo de Nervio Periférico
  Bloqueo Femoral / Ciático
  Anestesia Local con Sedación
  Anestesia Tópica
  Sedación Consciente
].each do |name|
  AnesthesiaType.find_or_create_by(name: name)
end

# ── Tipos de Alta / Egreso ──
%w[
  Alta Voluntaria Alta Médica
  Traslado a Otro Centro Alta por Fuga
  Alta por Abandono Alta a Domicilio
].each do |name|
  DischargeType.find_or_create_by(name: name)
end

DischargeType.find_or_create_by(name: 'Defunción') do |d|
  d.requires_cause_of_death = true
end

# ── Rangos de Signos Vitales ──
signs_ranges = [
  { parameter: 'systolic_bp',   sex: 'all', age_min: 18, age_max: 150, min_normal: 100, max_normal: 140, min_alert: 90,   max_alert: 180 },
  { parameter: 'diastolic_bp',  sex: 'all', age_min: 18, age_max: 150, min_normal: 60,  max_normal: 90,  min_alert: 50,   max_alert: 110 },
  { parameter: 'heart_rate',    sex: 'all', age_min: 18, age_max: 150, min_normal: 60,  max_normal: 100, min_alert: 40,   max_alert: 140 },
  { parameter: 'respiratory_rate', sex: 'all', age_min: 18, age_max: 150, min_normal: 12, max_normal: 20, min_alert: 8,    max_alert: 30 },
  { parameter: 'temperature',   sex: 'all', age_min: 18, age_max: 150, min_normal: 360, max_normal: 375, min_alert: 350,  max_alert: 390 },
  { parameter: 'oxygen_saturation', sex: 'all', age_min: 18, age_max: 150, min_normal: 95, max_normal: 100, min_alert: 90,  max_alert: 100 },
  { parameter: 'glucose',       sex: 'all', age_min: 18, age_max: 150, min_normal: 70,  max_normal: 110, min_alert: 50,   max_alert: 250 },
  { parameter: 'heart_rate',    sex: 'all', age_min: 0,  age_max: 1,   min_normal: 120, max_normal: 160, min_alert: 80,   max_alert: 200 },
  { parameter: 'heart_rate',    sex: 'all', age_min: 1,  age_max: 3,   min_normal: 90,  max_normal: 150, min_alert: 60,   max_alert: 180 },
  { parameter: 'heart_rate',    sex: 'all', age_min: 3,  age_max: 8,   min_normal: 80,  max_normal: 130, min_alert: 60,   max_alert: 160 },
  { parameter: 'heart_rate',    sex: 'all', age_min: 8,  age_max: 12,  min_normal: 70,  max_normal: 110, min_alert: 50,   max_alert: 140 },
  { parameter: 'systolic_bp',   sex: 'all', age_min: 0,  age_max: 1,   min_normal: 70,  max_normal: 100, min_alert: 60,   max_alert: 110 },
  { parameter: 'systolic_bp',   sex: 'all', age_min: 1,  age_max: 3,   min_normal: 80,  max_normal: 110, min_alert: 70,   max_alert: 120 },
  { parameter: 'systolic_bp',   sex: 'all', age_min: 3,  age_max: 8,   min_normal: 85,  max_normal: 115, min_alert: 75,   max_alert: 125 },
  { parameter: 'systolic_bp',   sex: 'all', age_min: 8,  age_max: 12,  min_normal: 90,  max_normal: 120, min_alert: 80,   max_alert: 130 },
  { parameter: 'temperature',   sex: 'all', age_min: 0,  age_max: 12,  min_normal: 365, max_normal: 375, min_alert: 350,  max_alert: 390 },
  { parameter: 'oxygen_saturation', sex: 'all', age_min: 0, age_max: 12, min_normal: 95, max_normal: 100, min_alert: 90,  max_alert: 100 },
]

signs_ranges.each do |sr|
  VitalSignsRange.find_or_create_by(
    parameter: sr[:parameter], sex: sr[:sex], age_min: sr[:age_min], age_max: sr[:age_max]
  ) do |r|
    r.min_normal = sr[:min_normal]
    r.max_normal = sr[:max_normal]
    r.min_alert = sr[:min_alert]
    r.max_alert = sr[:max_alert]
  end
end

puts "\n>> Seed completado: #{Specialty.count} especialidades, #{Doctor.count} medicos, #{DoctorSchedule.count} horarios"
puts "   #{Area.count} areas, #{Room.count} salas, #{LabParameterGroup.count} grupos, #{LabParameter.count} parametros"
puts "   #{MedicationRoute.count} vias, #{MedicationPresentation.count} presentaciones, #{MedicationConcentration.count} concentraciones"
puts "   #{Medication.count} medicamentos, #{Diagnosis.count} diagnosticos, #{AllergenCategory.count} cat. alergias"
puts "   #{Allergen.count} alergenos, #{SurgeryCategory.count} cat. cirugia, #{SurgeryProcedure.count} procedimientos"
puts "   #{AnesthesiaType.count} tipos anestesia, #{DischargeType.count} tipos alta, #{VitalSignsRange.count} rangos signos"
