class RoomRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :name
  property :patient_id
  property :room_type
  property :area_id

  property :area_name, exec_context: :decorator

  def area_name
    represented.area&.name
  end
end
