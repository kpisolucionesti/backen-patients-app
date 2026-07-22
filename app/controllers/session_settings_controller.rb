class SessionSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    settings = SessionSetting.first_or_initialize
    render json: settings
  end

  def update
    settings = SessionSetting.first_or_initialize
    if settings.update(session_settings_params)
      UserActivityLog.create!(user: @current_user, action: 'update_session_settings', description: "Actualizó configuración de sesiones")
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

  def session_settings_params
    params.permit(:idle_timeout_minutes, :allow_concurrent_sessions)
  end
end
