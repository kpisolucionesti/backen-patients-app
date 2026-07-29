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

User.find_or_create_by(email: 'admin@emerboard.com') do |u|
  u.username = 'admin'
  u.password = 'Admin123456!'
  u.password_confirmation = 'Admin123456!'
  u.name = 'Admin'
  u.profile = Profile.find_by(name: 'Administrador')
  u.status = 'active'
  u.confirmed_at = Time.current
end

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
