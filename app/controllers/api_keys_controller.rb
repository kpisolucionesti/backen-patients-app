class ApiKeysController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_record, only: [:show, :update, :destroy, :regenerate]

  def index
    render json: ApiKey.order(created_at: :desc).as_json(except: [:key]), status: :ok
  end

  def show
    render json: @record.as_json, status: :ok
  end

  def create
    record = ApiKey.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_api_key', description: "Creo API key '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_api_key', description: "Actualizo API key '#{@record.name}'")
    render json: @record.as_json(except: [:key]), status: :ok
  end

  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_api_key', description: "Elimino API key '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  def regenerate
    @record.regenerate!
    UserActivityLog.create!(user: @current_user, action: 'regenerate_api_key', description: "Regenero API key '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  private

  def record_params
    params.permit(:name, :expires_at, :is_active).tap do |p|
      p[:scopes] = params[:scopes] if params[:scopes].present?
    end
  end

  def set_record
    @record = ApiKey.find(params[:id])
  end

  def require_admin!
    unless @current_user&.admin?
      render json: { error: 'No autorizado' }, status: :forbidden
    end
  end
end
