class PatientGynecologicalHistoryRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :patient_id
  property :evento
  property :fecha_ultimo_evento
  property :observaciones
end
