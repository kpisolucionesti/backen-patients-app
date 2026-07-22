class EmergencyModesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    mode = EmergencyMode.first_or_initialize
    render json: format_mode(mode)
  end

  def update
    mode = EmergencyMode.first_or_initialize
    if mode.update(emergency_mode_params)
      UserActivityLog.create!(user: @current_user, action: 'update_emergency_mode', description: "Actualizó configuración de modo emergencia")
      render json: format_mode(mode), status: :ok
    else
      render json: { error: mode.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def block
    mode = EmergencyMode.block_system!(
      user: @current_user,
      message: params[:block_message],
      scheduled_unblock_at: params[:scheduled_unblock_at]
    )
    UserActivityLog.create!(user: @current_user, action: 'block_system', description: "Bloqueó el sistema (modo emergencia)")
    render json: format_mode(mode), status: :ok
  end

  def unblock
    mode = EmergencyMode.unblock_system!
    UserActivityLog.create!(user: @current_user, action: 'unblock_system', description: "Desbloqueó el sistema")
    render json: format_mode(mode), status: :ok
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def emergency_mode_params
    params.permit(:system_blocked, :block_message, :scheduled_unblock_at)
  end

  def format_mode(m)
    {
      id: m.id,
      system_blocked: m.system_blocked,
      block_message: m.block_message,
      blocked_at: m.blocked_at,
      blocked_by_id: m.blocked_by_id,
      scheduled_unblock_at: m.scheduled_unblock_at,
    }
  end
end
