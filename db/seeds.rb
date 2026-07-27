UserActivityLog.destroy_all
DoctorSchedule.destroy_all
EmergencyDoctor.destroy_all
Emergency.destroy_all
Note.destroy_all
Patient.destroy_all
Area.destroy_all
Room.destroy_all
Doctor.destroy_all
Specialty.destroy_all
User.destroy_all
Profile.destroy_all

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

Profile.create!(
  name: 'Administrador',
  description: 'Acceso completo a todos los modulos',
  permissions: admin_permissions + ['areas.view', 'areas.create', 'areas.edit', 'areas.delete', 'rooms.create', 'rooms.edit', 'rooms.delete']
)

Profile.create!(
  name: 'User',
  description: 'Acceso basico a visualizar emergencias e historial',
  permissions: ['emergencia.view', 'emergencia.create', 'emergencia.assign_room', 'historial.view', 'pacientes.view', 'pacientes.edit']
)

admin_profile = Profile.find_by(name: 'Administrador')

User.create!(
  email: "admin@emerboard.com",
  username: "admin",
  password: "Admin123456!",
  password_confirmation: "Admin123456!",
  name: "Admin",
  profile: admin_profile,
  status: 'active',
  confirmed_at: Time.current
)

adulto_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Cubiculo 3',
    'Cubiculo 4',
    'Cubiculo 5',
    'Cubiculo 6',
    'Cirugia Menor',
    'Consultorio',
    'Traumashock',
    'Sillon 1',
    'Sillon 2',
    'Sillon 3',
    'Sillon 4',
]

kids_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Consultorio',
    'Traumashock',
]

specialty_names = [
  'CIRUGIA PLASTICA', 'CIRUGIA GENERAL', 'ODONTOLOGIA', 'NEUROCIRUGIA',
  'ORL', 'GINECOLOGIA', 'GASTROENTEROLOGIA', 'NEUMONOLOGIA',
  'TRAUMATOLOGIA', 'INTENSIVISTA', 'UROLOGIA', 'MEDICINA INTERNA',
  'OFTALMOLOGIA', 'CARDIOLOGIA'
]

specialties = {}
specialty_names.each do |name|
  specialties[name] = Specialty.create!(name: name, description: "Especialidad de #{name.downcase}")
end

medicos = [
  { name: "ALBA AMUNDARAY",      specialty: "CIRUGIA PLASTICA" },
  { name: "ALEXANDER MORALES",   specialty: "CIRUGIA GENERAL" },
  { name: "ANIBAL ROJAS",        specialty: "ODONTOLOGIA" },
  { name: "AURA CONTRERAS",      specialty: "NEUROCIRUGIA" },
  { name: "CARLA GONZALEZ",      specialty: "ORL" },
  { name: "CRUZ GARBAN",         specialty: "GINECOLOGIA" },
  { name: "DAVID MAGO",          specialty: "GASTROENTEROLOGIA" },
  { name: "EDGAR VALOA",         specialty: "NEUMONOLOGIA" },
  { name: "EDUARDO BILBAO",      specialty: "TRAUMATOLOGIA" },
  { name: "FRANKY TORRES",       specialty: "INTENSIVISTA" },
  { name: "GERSON ZAMBRANO",     specialty: "INTENSIVISTA" },
  { name: "GIANCARLO ROTUNNO",   specialty: "UROLOGIA" },
  { name: "GLADYS MOTA",         specialty: "MEDICINA INTERNA" },
  { name: "IGOR MARQUEZ",        specialty: "NEUROCIRUGIA" },
  { name: "JENNY MARTINEZ",      specialty: "MEDICINA INTERNA" },
  { name: "JHOSBELIS GARCIA",    specialty: "MEDICINA INTERNA" },
  { name: "JOSE MEDINA",         specialty: "UROLOGIA" },
  { name: "JOSE NEGRIN",         specialty: "TRAUMATOLOGIA" },
  { name: "JOSE RAMON NOYA",     specialty: "CIRUGIA GENERAL" },
  { name: "JOSE SANGUINO",       specialty: "NEUROCIRUGIA" },
  { name: "LETTY CHAVEZ",        specialty: "TRAUMATOLOGIA" },
  { name: "LILIANA DE LA FUENTE",specialty: "CIRUGIA GENERAL" },
  { name: "MARIANA LOSSADA",     specialty: "ORL" },
  { name: "MARISELA MENDEZ",     specialty: "OFTALMOLOGIA" },
  { name: "MAYDA MARTINEZ",      specialty: "GINECOLOGIA" },
  { name: "MERFRA PINERO",       specialty: "GINECOLOGIA" },
  { name: "NACCY MORALES",       specialty: "ODONTOLOGIA" },
  { name: "NATALIA MOTA",        specialty: "CIRUGIA GENERAL" },
  { name: "NORIS MARTINEZ",      specialty: "GINECOLOGIA" },
  { name: "PETER KNAPP",         specialty: "CIRUGIA GENERAL" },
  { name: "RAFAEL CHAVERO",      specialty: "CARDIOLOGIA" },
  { name: "RICCIARDELLI GAETANO",specialty: "GINECOLOGIA" },
  { name: "RUBEN SIFONTES",      specialty: "OFTALMOLOGIA" },
  { name: "SANDRA PEREZ",        specialty: "CARDIOLOGIA" },
  { name: "SUSANA SALAZAR",      specialty: "MEDICINA INTERNA" },
  { name: "YASMIN ALFONZO",      specialty: "GASTROENTEROLOGIA" },
  { name: "ZAIDA GARRIDO",       specialty: "CIRUGIA PLASTICA" }
]

adulto_area = Area.create!(name: 'Emergencia Adultos', room_type: 'adulto', description: 'Área de emergencia para pacientes adultos')
kids_area  = Area.create!(name: 'Emergencia Pediatría', room_type: 'pediatria', description: 'Área de emergencia para pacientes pediátricos')
quirofano1 = Area.create!(name: 'Quirófano 1', room_type: 'quirofano', description: 'Quirófano principal')
quirofano2 = Area.create!(name: 'Quirófano 2', room_type: 'quirofano', description: 'Quirófano secundario')
quirofano3 = Area.create!(name: 'Quirófano 3', room_type: 'quirofano', description: 'Quirófano de emergencias')

adulto_rooms.each do |i|
    Room.create(name: i, area: adulto_area)
end

kids_rooms.each do |i|
    Room.create(name: i, area: kids_area)
end

medicos.each do |i|
    Doctor.create!(name: i[:name], specialty: specialties[i[:specialty]])
end

ClinicalStudyClassification.find_or_create_by!(key: 'lab') do |c|
  c.name = 'Laboratorio'
  c.color = '#1565c0'
  c.sort_order = 1
end
ClinicalStudyClassification.find_or_create_by!(key: 'xray') do |c|
  c.name = 'Radiografía'
  c.color = '#6a1b9a'
  c.sort_order = 2
end
ClinicalStudyClassification.find_or_create_by!(key: 'eco') do |c|
  c.name = 'Ecosonograma'
  c.color = '#ff8f00'
  c.sort_order = 3
end
ClinicalStudyClassification.find_or_create_by!(key: 'ct') do |c|
  c.name = 'Tomografía'
  c.color = '#2e7d32'
  c.sort_order = 4
end
ClinicalStudyClassification.find_or_create_by!(key: 'mri') do |c|
  c.name = 'Resonancia Magnética'
  c.color = '#c62828'
  c.sort_order = 5
end
