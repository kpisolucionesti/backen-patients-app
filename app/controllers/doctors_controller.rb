class DoctorsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_doctor, only: [:show, :update, :destroy]

    def index
        authorize!('medicos.view')
        doctors = Doctor.all
        render json: ::DoctorRepresenter.for_collection.new(doctors),status: :ok
    end

    def show
        authorize!('medicos.view')
        render json: DoctorRepresenter.new(@doctor), status: :ok
    end

    def create
        authorize!('medicos.create')
        doctor = Doctor.create!(doctor_params)
        render json: DoctorRepresenter.new(doctor), status: :created
    end

    def update
        authorize!('medicos.edit')
        @doctor.update!(doctor_params)
        render json: DoctorRepresenter.new(@doctor), status: :ok
    end

    def destroy
        authorize!('medicos.suspend')
        @doctor.destroy!
        head :no_content
    end

    private

    def doctor_params
        params.permit(:name, :speciality, :status)
    end

    def set_doctor
        @doctor = Doctor.find(params[:id])
    end
end
