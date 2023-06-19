class PatientRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :ci
    property :name
    property :age
    property :gender
    property :current_doctor
    property :current_diagnostic
    property :treatment
    property :ingress_date
    property :medical_exit
    property :status
    property :observations
    property :transfer
end