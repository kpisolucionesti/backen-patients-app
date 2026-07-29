class MedicationRoutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: records, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = MedicationRoute.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_medication_route', description: "Creo via de medicamento '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_medication_route', description: "Actualizo via de medicamento '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_medication_route', description: "Elimino via de medicamento '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def records
    MedicationRoute.active.ordered
  end

  def record_params
    params.permit(:name, :is_active)
  end

  def set_record
    @record = MedicationRoute.find(params[:id])
  end
end
