class EmergencyRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :patient_id
    property :ingress_date
    property :status
    property :medical_exit
    property :diagnostic
    property :treatment
    property :observations
    property :transfer
    property :created_at
    property :updated_at
    property :egress_at
    property :classification
    property :cause_of_death
    property :reason_for_consultation
    property :current_illness
    property :discharge_note
    property :admission_note

    property :created_by do
        property :name
        property :email
    end

    property :patient, decorator: PatientRepresenter

    collection :doctors do
        property :id
        property :name
        property :speciality
    end

    property :primary_doctor do
        property :id
        property :name
        property :speciality
    end

    collection :consulting_doctors do
        property :id
        property :name
        property :speciality
    end

    collection :medical_plans, decorator: MedicalPlanRepresenter

    collection :vital_signs, decorator: VitalSignRepresenter
end
