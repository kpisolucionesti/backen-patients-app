class PatientsController < ApplicationController
    before_action :set_patient, only: [:update, :destroy, :show]
    
    def index
        patients = Patient.all
        render json: ::PatientRepresenter.for_collection.new(patients),status: :ok
    end

    def create
        patient = Patient.new(patient_params)
        if patient.save
            diagnostic = patient.diagnostics.create(diagnostic: extra_params[:current_diagnostic],doctor_id: extra_params[:current_doctor])
            diagnostic.treatments.create(name: extra_params[:treatment])
            render json: ::PatientRepresenter.new(patient),status: :created
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end
    end

    def update
        if @patient.update(patient_params)
            if extra_params[:current_diagnostic] != @patient.current_diagnostic.diagnostic
                diagnostic = @patient.diagnostics.create(diagnostic: extra_params[:current_diagnostic],doctor_id: extra_params[:current_doctor])
                diagnostic.treatments.create(name: extra_params[:treatment])
            end
            render json: ::PatientRepresenter.new(@patient),status: :ok
        else
            render json: {error: "No se pudo guardar"},status: :unprocessable_entity
        end    
    end

    private
    def patient_params
        params.permit(:ci, :name, :age, :gender, :status, :medical_exit)
    end

    def extra_params
        params.permit(:current_doctor,  :current_diagnostic, :treatment)
    end

    def set_patient
        @patient = Patient.find(params[:id])
    end
end