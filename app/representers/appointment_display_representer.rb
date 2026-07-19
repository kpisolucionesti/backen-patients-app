class AppointmentDisplayRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :name
  property :location
  property :specialty_id
  property :is_active
  property :public_id
  property :created_at
  property :updated_at

  property :specialty do
    property :id
    property :name
  end
end
