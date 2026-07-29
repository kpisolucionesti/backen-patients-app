class DynamicSetting < ApplicationRecord
  belongs_to :company, optional: true

  validates :category, presence: true

  scope :global, -> { where(company_id: nil) }
  scope :for_company, ->(id) { where(company_id: id) }

  after_initialize :apply_defaults, if: :new_record?

  def resolved_data
    (settings_data || {}).deep_symbolize_keys
  end

  private

  def apply_defaults
    return if schema_definition.blank?

    defaults = {}
    (schema_definition['properties'] || {}).each do |key, prop|
      defaults[key] = prop['default'] if prop.key?('default')
    end
    self.settings_data = defaults.deep_merge(settings_data || {})
  end
end
