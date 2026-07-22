class StorageConfigurationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    config = StorageConfiguration.first_or_initialize
    render json: format_config(config)
  end

  def update
    config = StorageConfiguration.first_or_initialize
    if config.update(storage_params)
      UserActivityLog.create!(user: @current_user, action: 'update_storage_config', description: "Actualizó configuración de almacenamiento")
      render json: format_config(config), status: :ok
    else
      render json: { error: config.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def storage_params
    params.permit(:provider, :endpoint, :region, :bucket, :access_key_id, :secret_access_key, :local_path, :max_file_size_mb, :use_ssl)
  end

  def format_config(c)
    {
      id: c.id,
      provider: c.provider,
      endpoint: c.endpoint,
      region: c.region,
      bucket: c.bucket,
      access_key_id: c.access_key_id,
      secret_access_key: c.secret_access_key.present?,
      local_path: c.local_path,
      max_file_size_mb: c.max_file_size_mb,
      use_ssl: c.use_ssl,
    }
  end
end
