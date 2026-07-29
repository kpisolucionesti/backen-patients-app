class AllergenCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: AllergenCategory.active.ordered.as_json, status: :ok
  end
  def show; render json: @record.as_json; end
  def create
    r = AllergenCategory.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_allergen_category', description: "Creo categoria de alergia '#{r.name}'")
    render json: r.as_json, status: :created
  end
  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_allergen_category', description: "Actualizo categoria de alergia '#{@record.name}'")
    render json: @record.as_json
  end
  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_allergen_category', description: "Elimino categoria de alergia '#{@record.name}'")
    @record.destroy!; head :no_content
  end
  private
  def record_params; params.permit(:name, :is_active); end
  def set_record; @record = AllergenCategory.find(params[:id]); end
end
