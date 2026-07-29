class MedicationConcentrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: MedicationConcentration.active.ordered.as_json, status: :ok
  end
  def show; render json: @record.as_json; end
  def create
    r = MedicationConcentration.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_medication_concentration', description: "Creo concentracion '#{r.name}'")
    render json: r.as_json, status: :created
  end
  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_medication_concentration', description: "Actualizo concentracion '#{@record.name}'")
    render json: @record.as_json
  end
  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_medication_concentration', description: "Elimino concentracion '#{@record.name}'")
    @record.destroy!; head :no_content
  end
  private
  def record_params; params.permit(:name, :is_active); end
  def set_record; @record = MedicationConcentration.find(params[:id]); end
end
