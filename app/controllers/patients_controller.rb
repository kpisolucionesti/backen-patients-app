class PatientsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_patient, only: [:update, :destroy, :show]

    def index
        authorize!('pacientes.view')
        patients = Patient.all

        if params[:q].present?
            q = "%#{params[:q]}%"
            patients = patients.where("name ILIKE ? OR lastname ILIKE ? OR ci ILIKE ?", q, q, q)
        end

        render json: ::PatientRepresenter.for_collection.new(patients), status: :ok
    end

    def show
        authorize!('pacientes.view')
        render json: ::PatientRepresenter.new(@patient), status: :ok
    end

    def create
        authorize!('pacientes.edit')
        patient = Patient.new(patient_params)
        patient.created_by = @current_user
        if patient.save
            render json: ::PatientRepresenter.new(patient), status: :created
        else
            render json: { error: "No se pudo guardar", errors: patient.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def find_by_ci
        authorize!('pacientes.view')
        clean_ci = params[:ci]&.gsub(/\D/, '')
        patient = Patient.find_by(ci: clean_ci)
        if patient
            render json: ::PatientRepresenter.new(patient), status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def update
        authorize!('pacientes.edit')
        if @patient.update(patient_params)
            render json: ::PatientRepresenter.new(@patient), status: :ok
        else
            render json: { error: "No se pudo guardar" }, status: :unprocessable_entity
        end
    end

    private

    def patient_params
        params.permit(:ci, :name, :lastname, :birthday, :gender, :representante, :representante_ci)
    end

    def set_patient
        @patient = Patient.find(params[:id])
    end
end
