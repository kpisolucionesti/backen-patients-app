class SurgeryCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: SurgeryCategory.active.ordered.as_json, status: :ok
  end
  def show; render json: @record.as_json; end
  def create
    r = SurgeryCategory.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_surgery_category', description: "Creo categoria de cirugia '#{r.name}'")
    render json: r.as_json, status: :created
  end
  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_surgery_category', description: "Actualizo categoria de cirugia '#{@record.name}'")
    render json: @record.as_json
  end
  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_surgery_category', description: "Elimino categoria de cirugia '#{@record.name}'")
    @record.destroy!; head :no_content
  end
  private
  def record_params; params.permit(:name, :is_active); end
  def set_record; @record = SurgeryCategory.find(params[:id]); end
end
