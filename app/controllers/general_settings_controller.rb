class GeneralSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    settings = GeneralSetting.first_or_initialize
    render json: settings
  end

  def update
    settings = GeneralSetting.first_or_initialize
    if settings.update(general_settings_params)
      UserActivityLog.create!(user: @current_user, action: 'update_general_settings', description: "Actualizó configuraciones generales")
      render json: settings, status: :ok
    else
      render json: { error: settings.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def general_settings_params
    params.permit(:timezone, :date_format, :time_format, :locale, :notifications_enabled)
  end
end
