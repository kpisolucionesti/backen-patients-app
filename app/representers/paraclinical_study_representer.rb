class ParaclinicalStudyRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :study_type
  property :description
  property :created_at
end
