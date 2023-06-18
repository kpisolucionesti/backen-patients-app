class DoctorRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :name
    property :speciality
end