class PatientRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :ci
    property :name
    property :lastname
    property :age
    property :birthday
    property :gender
    property :representante
    property :representante_ci
end
