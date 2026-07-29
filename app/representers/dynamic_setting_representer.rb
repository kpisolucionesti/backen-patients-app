class DynamicSettingRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :company_id
  property :category
  property :settings_data
  property :schema_definition
  property :created_at
  property :updated_at
end
