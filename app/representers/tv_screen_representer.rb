class TvScreenRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :location
  property :is_active
  property :public_id
  property :created_at
  property :updated_at
  property :connected?, as: :is_connected
end
