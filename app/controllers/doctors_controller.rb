class DoctorsController < ApplicationController
    def index
        doctors = Doctor.all
        render json: ::DoctorRepresenter.for_collection.new(doctors),status: :ok
    end
end
