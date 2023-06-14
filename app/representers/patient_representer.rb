class PatientRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :ci
    property :name
    property :age
    property :gender
    property :status
    property :medical_exit
    property :current_doctor, exec_context: :decorator
    property :current_diagnostic, exec_context: :decorator
    property :treatment, exec_context: :decorator

    def current_doctor
        represented.current_doctor.name
    end

    def current_diagnostic
        represented.current_diagnostic.diagnostic
    end

    def treatment
        represented.current_diagnostic.treatments.last.name
    end
end