class SurgeryRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :hospitalization_id
  property :surgery_type
  property :description
  property :surgeon_name
  property :surgery_date
  property :status
  property :preop_notes
  property :postop_notes
  property :result
  property :created_at
  property :updated_at

  collection_representer class: Surgery
end
