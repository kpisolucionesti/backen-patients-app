class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_area, only: [:show, :update, :destroy]

  def index
    authorize!('areas.view')
    areas = Area.order(:name)
    render json: ::AreaRepresenter.for_collection.new(areas), status: :ok
  end

  def show
    authorize!('areas.view')
    render json: ::AreaRepresenter.new(@area), status: :ok
  end

  def create
    authorize!('areas.create')
    area = Area.create!(area_params)
    UserActivityLog.create!(user: @current_user, action: 'create_area', description: "Creó área '#{area.name}'")
    render json: ::AreaRepresenter.new(area), status: :created
  end

  def update
    authorize!('areas.edit')
    @area.update!(area_params)
    UserActivityLog.create!(user: @current_user, action: 'update_area', description: "Actualizó área '#{@area.name}'")
    render json: ::AreaRepresenter.new(@area), status: :ok
  end

  def destroy
    authorize!('areas.delete')
    UserActivityLog.create!(user: @current_user, action: 'delete_area', description: "Eliminó área '#{@area.name}'")
    @area.destroy!
    head :no_content
  end

  private

  def area_params
    params.permit(:name, :room_type, :description)
  end

  def set_area
    @area = Area.find(params[:id])
  end
end
