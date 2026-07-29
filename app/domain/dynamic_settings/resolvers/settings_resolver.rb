module DynamicSettings
  module Resolvers
    class SettingsResolver
      def self.resolve(category, company_id = nil)
        global = DynamicSetting.global.find_by(category: category)
        tenant = company_id ? DynamicSetting.for_company(company_id).find_by(category: category) : nil

        schema = (global&.schema_definition || {}).deep_merge(tenant&.schema_definition || {})
        data   = (global&.settings_data || {}).deep_merge(tenant&.settings_data || {})

        { settings_data: data, schema_definition: schema }
      end
    end
  end
end
