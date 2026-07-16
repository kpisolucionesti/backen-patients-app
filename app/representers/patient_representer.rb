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
    property :last_visit_date
    property :disabled

    collection :allergies, decorator: PatientAllergyRepresenter
    collection :antecedents, decorator: PatientAntecedentRepresenter
end
