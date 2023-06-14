class DoctorRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :name
end