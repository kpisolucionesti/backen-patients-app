class SpecialtiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_specialty, only: [:show, :update, :destroy]

  def index
    authorize!('especialidades.view')
    specialties = Specialty.order(:name)
    render json: ::SpecialtyRepresenter.for_collection.new(specialties), status: :ok
  end

  def show
    authorize!('especialidades.view')
    render json: ::SpecialtyRepresenter.new(@specialty), status: :ok
  end

  def create
    authorize!('especialidades.create')
    specialty = Specialty.create!(specialty_params)
    UserActivityLog.create!(user: @current_user, action: 'create_specialty', description: "Creó especialidad '#{specialty.name}'")
    render json: ::SpecialtyRepresenter.new(specialty), status: :created
  end

  def update
    authorize!('especialidades.edit')
    @specialty.update!(specialty_params)
    UserActivityLog.create!(user: @current_user, action: 'update_specialty', description: "Actualizó especialidad '#{@specialty.name}'")
    render json: ::SpecialtyRepresenter.new(@specialty), status: :ok
  end

  def destroy
    authorize!('especialidades.delete')
    UserActivityLog.create!(user: @current_user, action: 'delete_specialty', description: "Eliminó especialidad '#{@specialty.name}'")
    @specialty.destroy!
    head :no_content
  end

  private

  def specialty_params
    params.permit(:name, :description, :is_active)
  end

  def set_specialty
    @specialty = Specialty.find(params[:id])
  end
end
