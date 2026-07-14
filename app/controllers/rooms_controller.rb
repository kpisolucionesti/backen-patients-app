class RoomsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_room, only: [:update, :destroy, :show]

    def index
        authorize!('rooms.view')
        rooms = Room.all
        render json: ::RoomRepresenter.for_collection.new(rooms),status: :ok
    end

    def update
        authorize!('emergencia.assign_room')
        if @room.update!(room_params)
            render json: ::RoomRepresenter.new(@room),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    private
    def room_params
        params.permit(:name, :room_type, :patient_id)
    end

    def set_room
        @room = Room.find(params[:id])
    end

end
