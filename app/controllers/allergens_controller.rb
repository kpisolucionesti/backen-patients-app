class AllergensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    records = Allergen.active.ordered
    records = records.search(params[:q]) if params[:q].present?
    render json: records.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = Allergen.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_allergen', description: "Creo alergeno '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_allergen', description: "Actualizo alergeno '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_allergen', description: "Elimino alergeno '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:name, :category, :is_active)
  end

  def set_record
    @record = Allergen.find(params[:id])
  end
end
