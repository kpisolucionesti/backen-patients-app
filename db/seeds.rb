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

Profile.find_or_create_by!(name: 'Administrador') do |p|
  p.description = 'Acceso completo a todos los modulos'
  p.permissions = admin_permissions + ['areas.view', 'areas.create', 'areas.edit', 'areas.delete', 'rooms.create', 'rooms.edit', 'rooms.delete']
end

Profile.find_or_create_by!(name: 'User') do |p|
  p.description = 'Acceso basico a visualizar emergencias e historial'
  p.permissions = ['emergencia.view', 'emergencia.create', 'emergencia.assign_room', 'historial.view', 'pacientes.view', 'pacientes.edit']
end

User.find_or_create_by!(email: 'admin@emerboard.com') do |u|
  u.username = 'admin'
  u.password = 'Admin123456!'
  u.password_confirmation = 'Admin123456!'
  u.name = 'Admin'
  u.profile = Profile.find_by(name: 'Administrador')
  u.status = 'active'
  u.confirmed_at = Time.current
end

ClinicalStudyClassification.find_or_create_by!(key: 'laboratorios') do |c|
  c.name = 'Laboratorios'
  c.color = '#1565c0'
  c.sort_order = 10
end
ClinicalStudyClassification.find_or_create_by!(key: 'imagenologia') do |c|
  c.name = 'Imagenologia'
  c.color = '#7b1fa2'
  c.sort_order = 11
end
ClinicalStudyClassification.find_or_create_by!(key: 'banco_sangre') do |c|
  c.name = 'Banco de Sangre'
  c.color = '#c62828'
  c.sort_order = 12
end

# ── Catalogos ──

routes_data = [
  'Oral', 'Intravenosa', 'Intramuscular', 'Subcutanea',
  'Topica', 'Inhalatoria', 'Rectal', 'Oftalmica', 'Otica', 'Sublingual'
]
routes_data.each { |name| MedicationRoute.find_or_create_by!(name: name) }
oral_route = MedicationRoute.find_by!(name: 'Oral')

medications_data = [
  { name: 'Paracetamol', generic_name: 'Acetaminofen', presentation: 'Tableta', concentration: '500 mg' },
  { name: 'Ibuprofeno', generic_name: 'Ibuprofeno', presentation: 'Tableta', concentration: '400 mg' },
  { name: 'Omeprazol', generic_name: 'Omeprazol', presentation: 'Capsula', concentration: '20 mg' },
  { name: 'Amoxicilina', generic_name: 'Amoxicilina', presentation: 'Capsula', concentration: '500 mg' },
  { name: 'Ranitidina', generic_name: 'Ranitidina', presentation: 'Tableta', concentration: '150 mg' },
  { name: 'Metformina', generic_name: 'Metformina', presentation: 'Tableta', concentration: '850 mg' },
  { name: 'Enalapril', generic_name: 'Enalapril', presentation: 'Tableta', concentration: '10 mg' },
  { name: 'Losartan', generic_name: 'Losartan', presentation: 'Tableta', concentration: '50 mg' },
  { name: 'Atorvastatina', generic_name: 'Atorvastatina', presentation: 'Tableta', concentration: '20 mg' },
  { name: 'Metoclopramida', generic_name: 'Metoclopramida', presentation: 'Ampolla', concentration: '10 mg/2 mL' },
]
medications_data.each { |m| Medication.find_or_create_by!(name: m[:name]) { |rec| rec.assign_attributes(m.merge(medication_route: oral_route)) } }

allergens_data = [
  { name: 'Penicilina', category: 'medicamento' },
  { name: 'Sulfamidas', category: 'medicamento' },
  { name: 'AINEs', category: 'medicamento' },
  { name: 'Iodo', category: 'medicamento' },
  { name: 'Latex', category: 'latex' },
  { name: 'Mani', category: 'alimento' },
  { name: 'Mariscos', category: 'alimento' },
  { name: 'Huevo', category: 'alimento' },
  { name: 'Polvo domestico', category: 'ambiental' },
  { name: 'Polen', category: 'ambiental' },
]
allergens_data.each { |a| Allergen.find_or_create_by!(name: a[:name]) { |rec| rec.category = a[:category] } }

surgery_data = [
  { name: 'Apendicectomia', category: 'abdominal' },
  { name: 'Colecistectomia', category: 'abdominal' },
  { name: 'Hernioplastia inguinal', category: 'abdominal' },
  { name: 'Reduccion de fractura', category: 'traumatologia' },
  { name: 'Artroscopia de rodilla', category: 'traumatologia' },
  { name: 'Craneotomia', category: 'neurocirugia' },
  { name: 'Cesarea', category: 'ginecologica' },
  { name: 'Histerectomia', category: 'ginecologica' },
  { name: 'Amigdalectomia', category: 'otorrino' },
  { name: 'Catarata', category: 'oftalmologica' },
]
surgery_data.each { |s| SurgeryProcedure.find_or_create_by!(name: s[:name]) { |rec| rec.category = s[:category] } }

anesthesia_data = %w[General Regional Local Sedacion Bloqueo Mixta]
anesthesia_data.each { |name| AnesthesiaType.find_or_create_by!(name: name) }

discharge_data = [
  { name: 'Mejoria medica', requires_cause_of_death: false },
  { name: 'Referencia', requires_cause_of_death: false },
  { name: 'Contra opinion medica', requires_cause_of_death: false },
  { name: 'Fallecimiento', requires_cause_of_death: true },
]
discharge_data.each { |d| DischargeType.find_or_create_by!(name: d[:name]) { |rec| rec.requires_cause_of_death = d[:requires_cause_of_death] } }

presentations_data = %w[Tableta Capsula Ampolla Jarabe Solucion Inyectable Crema Unguento Supositorio Spray Gotas Parche]
presentations_data.each { |name| MedicationPresentation.find_or_create_by!(name: name) }

concentrations_data = %w[500mg 400mg 200mg 100mg 50mg 20mg 10mg 5mg 1g 250mg 100mg/mL 10mg/2mL]
concentrations_data.each { |name| MedicationConcentration.find_or_create_by!(name: name) }

allergen_categories_data = %w[Medicamento Alimento Ambiental Latex Otro]
allergen_categories_data.each { |name| AllergenCategory.find_or_create_by!(name: name) }

surgery_categories_data = %w[General Traumatologia Neurocirugia Cardiovascular Toracica Abdominal Urologica Ginecologica Oftalmologica Otorrino Maxilofacial Pediatrica Otros]
surgery_categories_data.each { |name| SurgeryCategory.find_or_create_by!(name: name) }
