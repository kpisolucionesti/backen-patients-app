class PatientFamilyAntecedentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :patient_id
  property :patologia
  property :parentesco
  property :valor
end
