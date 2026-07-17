class RoomsController < ApplicationController
  before_action :authenticate_tv_or_user!
  before_action :set_room, only: [:show, :update, :destroy]

  def index
    authorize!('rooms.view')
    rooms = Room.includes(:area).order(:name)
    render json: ::RoomRepresenter.for_collection.new(rooms), status: :ok
  end

  def show
    authorize!('rooms.view')
    render json: ::RoomRepresenter.new(@room), status: :ok
  end

  def create
    authorize!('rooms.create')
    room = Room.create!(room_params)
    render json: ::RoomRepresenter.new(room), status: :created
  end

  def update
    authorize!('emergencia.assign_room')
    @room.update!(room_params)
    render json: ::RoomRepresenter.new(@room), status: :ok
  end

  def destroy
    authorize!('rooms.delete')
    @room.destroy!
    head :no_content
  end

  private

  def room_params
    params.permit(:name, :area_id, :patient_id)
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
