class MedicationPresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: MedicationPresentation.active.ordered.as_json, status: :ok
  end
  def show; render json: @record.as_json; end
  def create
    r = MedicationPresentation.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_medication_presentation', description: "Creo presentacion '#{r.name}'")
    render json: r.as_json, status: :created
  end
  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_medication_presentation', description: "Actualizo presentacion '#{@record.name}'")
    render json: @record.as_json
  end
  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_medication_presentation', description: "Elimino presentacion '#{@record.name}'")
    @record.destroy!; head :no_content
  end
  private
  def record_params; params.permit(:name, :is_active); end
  def set_record; @record = MedicationPresentation.find(params[:id]); end
end
