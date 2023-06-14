class RoomsController < ApplicationController
    before_action :set_room, only: [:update, :destroy, :show]

    def index
        rooms = Room.all
        render json: ::RoomRepresenter.for_collection.new(rooms),status: :ok
    end

    def update
        if @room.update!(room_params)
            # if extra_params[:patient_id] != @room.patient_id
            #     patient = @room.patient.create(patient: extra_params[:patient_id])
            # end
            render json: ::RoomRepresenter.new(@room),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    private
    def room_params
        params.permit(:name, :room_type, :patient_id)
    end

    # def extra_params
    #     params.permit(:patient_id)
    # end

    def set_room
        @room = Room.find(params[:id])
    end

end
