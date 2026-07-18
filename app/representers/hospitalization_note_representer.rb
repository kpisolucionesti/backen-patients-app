class HospitalizationNoteRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :hospitalization_id
  property :note_type
  property :note_type_label
  property :shift
  property :shift_label
  property :subjective
  property :objective
  property :assessment
  property :plan
  property :recorded_at
  property :created_at
  property :updated_at

  property :created_by do
    property :id
    property :name
    property :lastname
  end
end
