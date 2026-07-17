class AreaRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :name
  property :room_type
  property :description
  property :rooms_count, exec_context: :decorator

  def rooms_count
    represented.rooms.size
  end
end
