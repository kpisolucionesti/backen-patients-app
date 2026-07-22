class PatientLifestyleHabitRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :patient_id
  property :habito
  property :concurrencia
  property :observaciones
end
