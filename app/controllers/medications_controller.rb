class MedicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    records = Medication.includes(:medication_route).ordered
    records = records.search(params[:q]) if params[:q].present?
    render json: records.as_json(include: { medication_route: { only: [:id, :name] } }), status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json(include: { medication_route: { only: [:id, :name] } }), status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = Medication.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_medication', description: "Creo medicamento '#{record.name}'")
    render json: record.as_json(include: { medication_route: { only: [:id, :name] } }), status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_medication', description: "Actualizo medicamento '#{@record.name}'")
    render json: @record.as_json(include: { medication_route: { only: [:id, :name] } }), status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_medication', description: "Elimino medicamento '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:name, :generic_name, :presentation, :concentration, :medication_route_id, :is_active)
  end

  def set_record
    @record = Medication.find(params[:id])
  end
end
