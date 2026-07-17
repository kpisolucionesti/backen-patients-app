class PatientAntecedentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :patient_id
  property :condition_type
  property :description
  property :diagnosed_at
  property :medication
  property :notes
  property :category
end
