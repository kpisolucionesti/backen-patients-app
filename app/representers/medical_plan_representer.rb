class MedicalPlanRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :description
  property :indication_type
  property :status
  property :completed_at
  property :created_at
  property :updated_at

  property :doctor do
    property :id
    property :name
    property :speciality
  end

  property :created_by do
    property :id
    property :name
  end
end
