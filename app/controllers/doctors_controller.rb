class DoctorsController < ApplicationController
    def index
        doctors = Doctor.all
        render json: ::DoctorRepresenter.for_collection.new(doctors),status: :ok
    end

    private
    def doctor_params
        params.require(:patient).permit(patient_id: [])
    end

end
