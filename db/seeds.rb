EmergencyDoctor.destroy_all
Emergency.destroy_all
Note.destroy_all
Patient.destroy_all
Room.destroy_all
Doctor.destroy_all
User.destroy_all
Profile.destroy_all

admin_permissions = [
  'emergencia.view', 'emergencia.create', 'emergencia.edit',
  'emergencia.triage', 'emergencia.discharge',
  'historial.view', 'historial.export',
  'configuraciones.view',
  'pacientes.view', 'pacientes.edit',
  'medicos.view', 'medicos.create', 'medicos.edit', 'medicos.suspend',
  'usuarios.view', 'usuarios.create', 'usuarios.edit',
  'usuarios.suspend', 'usuarios.manage_permissions', 'usuarios.change_password',
  'perfiles.view', 'perfiles.create', 'perfiles.edit', 'perfiles.delete',
  'rooms.view',
  'notes.view', 'notes.create', 'notes.edit', 'notes.delete',
  'emergencia.assign_room',
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
  password: "123456",
  password_confirmation: "123456",
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

medicos=[
    {
        name: "ALBA AMUNDARAY",
        speciality: "CIRUGIA PLASTICA"
    },
    {
        name: "ALEXANDER MORALES",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "ANIBAL ROJAS",
        speciality: "ODONTOLOGIA"
    },
    {
        name: "AURA CONTRERAS",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "CARLA GONZALEZ",
        speciality: "ORL"
    },
    {
        name: "CRUZ GARBAN",
        speciality: "GINECOLOGIA"
    },
    {
        name: "DAVID MAGO",
        speciality: "GASTROENTEROLOGIA"
    },
    {
        name: "EDGAR VALOA",
        speciality: "NEUMONOLOGIA"
    },
    {
        name: "EDUARDO BILBAO",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "FRANKY TORRES",
        speciality: "INTENSIVISTA"
    },
    {
        name: "GERSON ZAMBRANO",
        speciality: "INTENSIVISTA"
    },
    {
        name: "GIANCARLO ROTUNNO",
        speciality: "UROLOGIA"
    },
    {
        name: "GLADYS MOTA",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "IGOR MARQUEZ",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "JENNY MARTINEZ",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "JHOSBELIS GARCIA",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "JOSE MEDINA",
        speciality: "UROLOGIA"
    },
    {
        name: "JOSE NEGRIN",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "JOSE RAMON NOYA",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "JOSE SANGUINO",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "LETTY CHAVEZ",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "LILIANA DE LA FUENTE",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "MARIANA LOSSADA",
        speciality: "ORL"
    },
    {
        name: "MARISELA MENDEZ",
        speciality: "OFTALMOLOGIA"
    },
    {
        name: "MAYDA MARTINEZ",
        speciality: "GINECOLOGIA"
    },
    {
        name: "MERFRA PINERO",
        speciality: "GINECOLOGIA"
    },
    {
        name: "NACCY MORALES",
        speciality: "ODONTOLOGIA"
    },
    {
        name: "NATALIA MOTA",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "NORIS MARTINEZ",
        speciality: "GINECOLOGIA"
    },
    {
        name: "PETER KNAPP",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "RAFAEL CHAVERO",
        speciality: "CARDIOLOGIA"
    },
    {
        name: "RICCIARDELLI GAETANO",
        speciality: "GINECOLOGIA"
    },
    {
        name: "RUBEN SIFONTES",
        speciality: "OFTALMOLOGIA"
    },
    {
        name: "SANDRA PEREZ",
        speciality: "CARDIOLOGIA"
    },
    {
        name: "SUSANA SALAZAR",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "YASMIN ALFONZO",
        speciality: "GASTROENTEROLOGIA"
    },
    {
        name: "ZAIDA GARRIDO",
        speciality: "CIRUGIA PLASTICA"
    }
]

adulto_area = Area.create!(name: 'Emergencia Adultos', room_type: 'adulto', description: 'Área de emergencia para pacientes adultos')
kids_area  = Area.create!(name: 'Emergencia Pediatría', room_type: 'pediatria', description: 'Área de emergencia para pacientes pediátricos')

adulto_rooms.each do |i|
    Room.create(name: i, area: adulto_area)
end

kids_rooms.each do |i|
    Room.create(name: i, area: kids_area)
end

medicos.each do |i|
    Doctor.create(i)
end
