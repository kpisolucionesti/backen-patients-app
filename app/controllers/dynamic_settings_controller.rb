class DynamicSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:update]

  def show
    category = params[:category] || 'general'
    company_id = params[:company_id].presence
    resolved = DynamicSettings::Resolvers::SettingsResolver.resolve(category, company_id)

    render json: { settings_data: resolved[:settings_data], schema_definition: resolved[:schema_definition] }, status: :ok
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
        action: 'update_dynamic_settings',
        description: "Actualizo configuracion dinamica: #{setting.category}"
      )
      render json: DynamicSettingRepresenter.new(setting).to_json, status: :ok
    else
      render json: { error: setting.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def categories
    render json: { categories: DynamicSettings::Resolvers::SettingsResolver.available_categories }, status: :ok
  end

  private

  def find_or_build_setting
    category = params[:category] || 'general'
    company_id = params[:company_id].presence

    setting = DynamicSetting.find_or_initialize_by(category: category, company_id: company_id)
    if setting.new_record? && setting.schema_definition.blank?
      setting.schema_definition = DynamicSettings::Resolvers::SettingsResolver.load_default_schema_for(category)
    end
    setting
  end

  def require_admin!
    unless @current_user&.admin?
      render json: { error: 'No autorizado' }, status: :forbidden
    end
  end
end
