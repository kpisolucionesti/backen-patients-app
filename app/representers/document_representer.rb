class DocumentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :attachable_type
  property :attachable_id
  property :description
  property :file_type
  property :report_type
  property :metadata
  property :order_number
  property :study_classification_id
  property :study_type
  property :observations
  property :status
  property :file_url
  property :file_name
  property :file_size
  property :created_at
  property :updated_at

  property :uploaded_by do
    property :id
    property :name
    property :lastname
  end

  property :study_classification do
    property :id
    property :name
    property :key
    property :color
  end

  collection_representer class: Document
end
