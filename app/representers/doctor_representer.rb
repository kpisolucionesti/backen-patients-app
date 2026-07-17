class DoctorRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :name
    property :speciality
    property :email
    property :phone
    property :status
end