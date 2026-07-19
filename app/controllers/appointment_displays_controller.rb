class AppointmentDisplaysController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_display, only: [:show, :update, :destroy]

  def index
    authorize!('citas.view')
    displays = AppointmentDisplay.order(:name)
    render json: ::AppointmentDisplayRepresenter.for_collection.new(displays), status: :ok
  end

  def show
    if @current_user
      render json: ::AppointmentDisplayRepresenter.new(@display), status: :ok
    else
      render json: { queue: @display.queue, display: { id: @display.id, name: @display.name } }, status: :ok
    end
  end

  def create
    authorize!('configuraciones.view')
    display = AppointmentDisplay.create!(display_params)
    UserActivityLog.create!(user: @current_user, action: 'create_display', description: "Creó pantalla de llamados '#{display.name}'")
    render json: ::AppointmentDisplayRepresenter.new(display), status: :created
  end

  def update
    authorize!('configuraciones.view')
    @display.update!(display_params)
    UserActivityLog.create!(user: @current_user, action: 'update_display', description: "Actualizó pantalla de llamados '#{@display.name}'")
    render json: ::AppointmentDisplayRepresenter.new(@display), status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_display', description: "Eliminó pantalla de llamados '#{@display.name}'")
    @display.destroy!
    head :no_content
  end

  private

  def display_params
    params.permit(:name, :location, :specialty_id, :is_active)
  end

  def set_display
    @display = if @current_user
                 AppointmentDisplay.find(params[:id])
               else
                 AppointmentDisplay.active.find_by!(public_id: params[:id])
               end
  end
end
