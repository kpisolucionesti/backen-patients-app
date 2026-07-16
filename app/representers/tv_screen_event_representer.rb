class TvScreenEventRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :event_type
  property :metadata
  property :created_at
end
