class DiagnosesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    records = Diagnosis.ordered
    records = records.search(params[:q]) if params[:q].present?
    render json: records.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = Diagnosis.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_diagnosis', description: "Creo diagnostico '#{record.code} - #{record.description}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_diagnosis', description: "Actualizo diagnostico '#{@record.code} - #{@record.description}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_diagnosis', description: "Elimino diagnostico '#{@record.code}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:code, :description, :category, :is_active)
  end

  def set_record
    @record = Diagnosis.find(params[:id])
  end
end
