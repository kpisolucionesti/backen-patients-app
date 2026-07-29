module DynamicSettings
  module Resolvers
    class SettingsResolver
      SCHEMAS_PATH = Rails.root.join('app', 'domain', 'dynamic_settings', 'schemas')

      def self.resolve(category, company_id = nil)
        global = DynamicSetting.global.find_by(category: category)
        tenant = company_id ? DynamicSetting.for_company(company_id).find_by(category: category) : nil

        schema = (global&.schema_definition || {}).deep_merge(tenant&.schema_definition || {})
        schema = load_default_schema_for(category) if schema.blank?

        data = (global&.settings_data || {}).deep_merge(tenant&.settings_data || {})

        { settings_data: data, schema_definition: schema }
      end

      def self.value_for(category, key, company_id: nil)
        data = resolve(category, company_id)[:settings_data]
        data&.dig(key)
      end

      def self.load_default_schema_for(category)
        file = SCHEMAS_PATH.join("#{category}.json")
        return JSON.parse(File.read(file)) if File.exist?(file)
        JSON.parse(File.read(SCHEMAS_PATH.join('default_schema.json')))
      rescue Errno::ENOENT
        {}
      end

      def self.available_categories
        Dir.glob(SCHEMAS_PATH.join('*.json')).map { |f| File.basename(f, '.json') }.sort
      end
    end
  end
end
