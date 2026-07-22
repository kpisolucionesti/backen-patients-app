class BackupConfigurationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    config = BackupConfiguration.first_or_initialize
    render json: format_config(config)
  end

  def update
    config = BackupConfiguration.first_or_initialize
    if config.update(backup_params)
      UserActivityLog.create!(user: @current_user, action: 'update_backup_config', description: "Actualizó configuración de copias de seguridad")
      render json: format_config(config), status: :ok
    else
      render json: { error: config.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def run_now
    config = BackupConfiguration.first_or_initialize
    BackupJob.perform_later(config.id) if defined?(BackupJob)
    UserActivityLog.create!(user: @current_user, action: 'run_backup', description: "Inició copia de seguridad manual")
    render json: { message: "Copia de seguridad iniciada" }, status: :ok
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def backup_params
    params.permit(:provider, :destination_path, :access_key_id, :secret_access_key, :region, :cron_schedule, :retention_days, :include_uploads, :is_active)
  end

  def format_config(c)
    {
      id: c.id,
      provider: c.provider,
      destination_path: c.destination_path,
      access_key_id: c.access_key_id,
      secret_access_key: c.secret_access_key.present?,
      region: c.region,
      cron_schedule: c.cron_schedule,
      retention_days: c.retention_days,
      include_uploads: c.include_uploads,
      is_active: c.is_active,
    }
  end
end
