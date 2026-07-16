class TvScreenSessionRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :auth_token
  property :ip_address
  property :last_seen_at
  property :revoked_at
  property :created_at
end
