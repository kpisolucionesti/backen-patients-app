class DocumentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :attachable_type
  property :attachable_id
  property :description
  property :file_type
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

  collection_representer class: Document
end
