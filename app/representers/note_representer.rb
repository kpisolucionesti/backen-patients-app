class NoteRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :note
    property :patient_id
    property :emergency_id
    property :created_at
end
