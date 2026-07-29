class AnesthesiaTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: AnesthesiaType.active.ordered.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = AnesthesiaType.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_anesthesia_type', description: "Creo tipo de anestesia '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_anesthesia_type', description: "Actualizo tipo de anestesia '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_anesthesia_type', description: "Elimino tipo de anestesia '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:name, :is_active)
  end

  def set_record
    @record = AnesthesiaType.find(params[:id])
  end
end
