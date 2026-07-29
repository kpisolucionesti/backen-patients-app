class PatientRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :ci
    property :name
    property :lastname
    property :age
    property :birthday
    property :gender
    property :medical_history_number
    property :representante
    property :representante_ci
    property :last_visit_date
    property :disabled
    property :patient_category
    property :mother_id

    collection :allergies, decorator: PatientAllergyRepresenter
    collection :antecedents, decorator: PatientAntecedentRepresenter
end
