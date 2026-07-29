class DischargeTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: DischargeType.active.ordered.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = DischargeType.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_discharge_type', description: "Creo tipo de alta '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_discharge_type', description: "Actualizo tipo de alta '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_discharge_type', description: "Elimino tipo de alta '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:name, :requires_cause_of_death, :is_active)
  end

  def set_record
    @record = DischargeType.find(params[:id])
  end
end
