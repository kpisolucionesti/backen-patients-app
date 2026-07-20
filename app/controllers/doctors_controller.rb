class DoctorsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_doctor, only: [:show, :update, :destroy]

    def index
        authorize!('medicos.view')
        doctors = Doctor.all
        if params[:emergency_id].present?
            emergency = Emergency.find(params[:emergency_id])
            exclude_ids = []
            exclude_ids << emergency.primary_doctor&.id
            if emergency.hospitalization
                exclude_ids << emergency.hospitalization.attending_doctor_id
                exclude_ids << emergency.hospitalization.admitting_doctor_id
            end
            exclude_ids.compact!
            doctors = doctors.where.not(id: exclude_ids) if exclude_ids.any?
        end
        render json: ::DoctorRepresenter.for_collection.new(doctors),status: :ok
    end

    def show
        authorize!('medicos.view')
        render json: DoctorRepresenter.new(@doctor), status: :ok
    end

    def create
        authorize!('medicos.create')
        doctor = Doctor.create!(doctor_params)
        UserActivityLog.create!(user: @current_user, action: 'create_doctor', description: "Creó médico '#{doctor.name}'")
        render json: DoctorRepresenter.new(doctor), status: :created
    end

    def update
        authorize!('medicos.edit')
        @doctor.update!(doctor_params)
        UserActivityLog.create!(user: @current_user, action: 'update_doctor', description: "Actualizó médico '#{@doctor.name}'")
        render json: DoctorRepresenter.new(@doctor), status: :ok
    end

    def destroy
        authorize!('medicos.suspend')
        UserActivityLog.create!(user: @current_user, action: 'delete_doctor', description: "Eliminó médico '#{@doctor.name}'")
        @doctor.destroy!
        head :no_content
    end

    private

    def doctor_params
        params.permit(:name, :specialty_id, :email, :phone, :status, :signature, :stamp)
    end

    def set_doctor
        @doctor = Doctor.find(params[:id])
    end
end
