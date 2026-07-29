class SurgeryProceduresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    records = SurgeryProcedure.active.ordered
    records = records.search(params[:q]) if params[:q].present?
    render json: records.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = SurgeryProcedure.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_surgery_procedure', description: "Creo procedimiento quirurgico '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_surgery_procedure', description: "Actualizo procedimiento quirurgico '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_surgery_procedure', description: "Elimino procedimiento quirurgico '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:code, :name, :category, :is_active)
  end

  def set_record
    @record = SurgeryProcedure.find(params[:id])
  end
end
