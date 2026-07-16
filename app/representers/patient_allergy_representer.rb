class PatientAllergyRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :patient_id
  property :allergy
  property :severity
  property :notes
end
