class InterconsultationRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :reason
  property :observations
  property :status
  property :created_at

  property :doctor_requested do
    property :id
    property :name
    property :speciality
  end

  property :requested_by do
    property :name
  end
end
