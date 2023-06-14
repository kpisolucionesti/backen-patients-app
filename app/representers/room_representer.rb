class RoomRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :room_type
    property :name
    property :patient_id
end