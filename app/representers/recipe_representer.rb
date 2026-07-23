class RecipeRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :doctor_id
  property :medication
  property :dosage
  property :frequency
  property :duration
  property :route
  property :indications
  property :created_at

  property :doctor do
    property :id
    property :name
    property :speciality
  end
end
