class DoctorRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :name
    property :specialty, decorator: SpecialtyRepresenter
    property :email
    property :phone
    property :status
    property :signature_url
    property :stamp_url
    property :has_signature
    property :has_stamp
    property :ci
    property :doctor_code
    property :sanidad_number
end