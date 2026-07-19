class DoctorRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :name
    property :specialty, decorator: SpecialtyRepresenter
    property :email
    property :phone
    property :status
end