class NoteRepresenter < Representable::Decorator
    include Representable::JSON
    property :id
    property :note
    property :patient_id
end