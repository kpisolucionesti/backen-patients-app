class WebhooksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_record, only: [:show, :update, :destroy, :test]

  def index
    render json: Webhook.order(:event, :url).as_json, status: :ok
  end

  def show
    render json: @record.as_json(include: { deliveries: { only: [:id, :event, :response_code, :created_at], methods: [], limit: 10, order: { created_at: :desc } } }), status: :ok
  end

  def create
    record = Webhook.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_webhook', description: "Creo webhook para '#{record.event}'")
    render json: record.as_json, status: :created
  end

  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_webhook', description: "Actualizo webhook para '#{@record.event}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_webhook', description: "Elimino webhook para '#{@record.event}'")
    @record.destroy!
    head :no_content
  end

  def test
    payload = { test: true, event: @record.event, timestamp: Time.current.iso8601 }
    delivery = @record.dispatch!(payload)
    render json: delivery.as_json, status: :ok
  end

  def deliveries
    @record = Webhook.find(params[:webhook_id])
    render json: @record.deliveries.recent.as_json, status: :ok
  end

  private

  def record_params
    params.permit(:url, :event, :secret, :is_active)
  end

  def set_record
    @record = Webhook.find(params[:id])
  end

  def require_admin!
    unless @current_user&.admin?
      render json: { error: 'No autorizado' }, status: :forbidden
    end
  end
end
