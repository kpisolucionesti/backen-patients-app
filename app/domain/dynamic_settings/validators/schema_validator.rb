require 'json_schemer'

module DynamicSettings
  module Validators
    class SchemaValidator
      def initialize(schema_definition)
        @schema = JSONSchemer.schema(schema_definition)
      end

      def validate(data)
        @schema.validate(data).map do |error|
          {
            field: error['data_pointer']&.gsub('/', ''),
            message: error['error'],
            type: error['type']
          }
        end
      end

      def valid?(data)
        @schema.valid?(data)
      end
    end
  end
end
