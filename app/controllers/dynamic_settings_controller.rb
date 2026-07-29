class DynamicSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:update]

  SCHEMA_PATH = Rails.root.join('app', 'domain', 'dynamic_settings', 'schemas', 'default_schema.json')

  def show
    category = params[:category] || 'general'
    company_id = params[:company_id].presence
    resolved = DynamicSettings::Resolvers::SettingsResolver.resolve(category, company_id)

    schema = resolved[:schema_definition]
    if schema.blank? || (schema.is_a?(Hash) && schema.empty?)
      schema = default_schema
    end

    data = resolved[:settings_data] || {}

    render json: { settings_data: data, schema_definition: schema }, status: :ok
  end

  def update
    setting = find_or_build_setting

    validator = DynamicSettings::Validators::SchemaValidator.new(setting.schema_definition)
    input = (params[:settings_data] || {}).to_unsafe_h

    errors = validator.validate(input)
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    setting.settings_data = setting.settings_data.deep_merge(input)
    if setting.save
      UserActivityLog.create!(
        user: @current_user,
        action: 'update',
        description: "Config dinámica actualizada: #{setting.category}"
      )
      render json: DynamicSettingRepresenter.new(setting).to_json, status: :ok
    else
      render json: { error: setting.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def find_or_build_setting
    category = params[:category] || 'general'
    company_id = params[:company_id].presence

    setting = DynamicSetting.find_or_initialize_by(category: category, company_id: company_id)
    if setting.new_record? && setting.schema_definition.blank?
      setting.schema_definition = default_schema
    end
    setting
  end

  def default_schema
    JSON.parse(File.read(SCHEMA_PATH))
  end

  def require_admin!
    unless @current_user&.is_admin
      render json: { error: 'No autorizado' }, status: :forbidden
    end
  end
end
