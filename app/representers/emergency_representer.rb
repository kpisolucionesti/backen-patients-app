class EmergencyRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :ingress_date
    property :status
    property :medical_exit
    property :patient_id
    property :doctor_id
    property :diagnostic
    property :treatment

    # def patient_id
    #     represented.patient_id.id
    # end

    # def doctor_id
    #     represented.doctor_id.id
    # end
end