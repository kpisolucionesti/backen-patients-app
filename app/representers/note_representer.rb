class NoteRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :note
    property :note_type
    property :patient_id
    property :emergency_id
    property :created_at

    property :created_by do
        property :id
        property :name
        property :lastname
    end
end
