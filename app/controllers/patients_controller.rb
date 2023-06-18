class PatientsController < ApplicationController
    before_action :set_patient, only: [:update, :destroy, :show]
    
    def index
        patients = Patient.all
        render json: ::PatientRepresenter.for_collection.new(patients),status: :ok
    end

    def create
        patient = Patient.new(patient_params)
        if patient.save
            render json: ::PatientRepresenter.new(patient),status: :created
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    def update
        if @patient.update(patient_params)
            render json: ::PatientRepresenter.new(@patient),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end    
    end

    private
    def patient_params
        params.permit(:ci, :name, :age, :gender, :status, :ingress_date, :medical_exit, :current_doctor, :current_diagnostic, :treatment)
    end

    def set_patient
        @patient = Patient.find(params[:id])
    end

end