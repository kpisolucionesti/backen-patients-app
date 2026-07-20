class PatientsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_patient, only: [:update, :destroy, :show]

    def index
        authorize!('pacientes.view')
        patients = Patient.all.includes(:emergencies).order(lastname: :asc)

        if params[:q].present?
            q = "%#{params[:q]}%"
            patients = patients.where("name ILIKE ? OR lastname ILIKE ? OR ci ILIKE ?", q, q, q)
        end

        total = patients.count
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i
        paginated = patients.offset((page - 1) * per_page).limit(per_page)

        render json: {
            data: ::PatientRepresenter.for_collection.new(paginated),
            total: total,
            page: page,
            per_page: per_page
        }, status: :ok
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
            if patient.disabled?
                render json: { error: 'Este paciente ha fallecido. Su registro esta prohibido' }, status: :unprocessable_entity
            else
                UserActivityLog.create!(user: @current_user, action: 'search_patient', description: "Buscó paciente #{patient.name} #{patient.lastname} por CI #{clean_ci}")
                render json: ::PatientRepresenter.new(patient), status: :ok
            end
        else
            render json: nil, status: :not_found
        end
    end

    def stats
        authorize!('pacientes.view')
        patient = Patient.find(params[:id])
        render json: patient.stats, status: :ok
    end

    def update
        authorize!('pacientes.edit')
        if @patient.disabled?
            render json: { error: 'No se puede modificar un paciente fallecido' }, status: :unprocessable_entity
            return
        end
        if @patient.update(patient_params)
            UserActivityLog.create!(user: @current_user, action: 'update_patient', description: "Editó datos del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
            render json: ::PatientRepresenter.new(@patient), status: :ok
        else
            render json: { error: "No se pudo guardar" }, status: :unprocessable_entity
        end
    end

    private

    def patient_params
        params.permit(:ci, :name, :lastname, :birthday, :gender, :representante, :representante_ci, :disabled, :medical_history_number)
    end

    def set_patient
        @patient = Patient.find(params[:id])
    end
end
