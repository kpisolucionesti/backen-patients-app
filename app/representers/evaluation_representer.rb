class EvaluationRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :doctor_id
  property :diagnostic_impression
  property :plan
  property :created_at
  property :updated_at

  property :doctor do
    property :id
    property :name
    property :speciality
  end

  property :created_by do
    property :name
  end
end
