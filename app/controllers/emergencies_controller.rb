class EmergenciesController < ApplicationController
    before_action :authenticate_tv_or_user!
    before_action :set_emergency, only: [:update, :destroy, :show]

    def index
        authorize!('emergencia.view')
        emergencies = Emergency.includes(:patient, :doctors, :medical_plans)

        if params[:status].present?
            emergencies = emergencies.where(status: params[:status])
        end

        if params[:q].present?
            q = "%#{params[:q]}%"
            patient_ids = Patient.where("name ILIKE ? OR lastname ILIKE ? OR ci ILIKE ?", q, q, q).pluck(:id)
            doctor_ids = Doctor.where("name ILIKE ?", q).pluck(:id)
            emergency_ids_from_doctors = EmergencyDoctor.where(doctor_id: doctor_ids, primary: true).pluck(:emergency_id)

            emergencies = emergencies.where(
                "emergencies.patient_id IN (?) OR emergencies.id IN (?)",
                patient_ids, emergency_ids_from_doctors
            )
        end

        if params[:from].present?
            emergencies = emergencies.where("ingress_date >= ?", params[:from])
        end

        if params[:to].present?
            emergencies = emergencies.where("ingress_date <= ?", params[:to])
        end

        if params[:patient_id].present?
            emergencies = emergencies.where(patient_id: params[:patient_id])
        end

        total = emergencies.count

        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i
        paginated = emergencies.offset((page - 1) * per_page).limit(per_page)

        render json: {
            data: ::EmergencyRepresenter.for_collection.new(paginated),
            total: total,
            page: page,
            per_page: per_page
        }, status: :ok
    end

    def show
        authorize!('emergencia.view')
        @emergency = Emergency.includes(:patient, :doctors, :medical_plans).find(params[:id])
        render json: ::EmergencyRepresenter.new(@emergency), status: :ok
    end

    def create
        authorize!('emergencia.create')
        if params[:patient_id].present? && Patient.find_by(id: params[:patient_id])&.disabled?
            render json: { error: 'No se puede crear una emergencia para un paciente fallecido' }, status: :unprocessable_entity
            return
        end
        if params[:patient_id].present? && Emergency.where(patient_id: params[:patient_id], status: [0, 1]).exists?
            render json: { error: 'El paciente ya tiene una emergencia activa. Debe cerrarla antes de crear una nueva.' }, status: :unprocessable_entity
            return
        end
        ActiveRecord::Base.transaction do
            emergency = Emergency.new(emergency_params)
            emergency.created_by = @current_user
            emergency.save!
            assign_doctors(emergency)
            patient = emergency.patient
            UserActivityLog.create!(user: @current_user, action: 'create_emergency', description: "Creó emergencia ##{emergency.id} para paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
            render json: ::EmergencyRepresenter.new(emergency), status: :created
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
        authorize!('emergencia.edit')
        ActiveRecord::Base.transaction do
            update_params = emergency_params
            if [2, 3, 4, 5].include?(update_params[:status].to_i) && !@emergency.egress_at && !params[:egress_at]
                update_params = update_params.merge(egress_at: Time.current)
            end
            old_status = @emergency.status
            @emergency.update!(update_params)
            assign_doctors(@emergency) if params[:doctors].present?
            patient = @emergency.patient
            status_changed = old_status != @emergency.status
            if status_changed
                status_labels = { 1 => 'Atendido', 2 => 'Alta', 3 => 'Ingresado', 4 => 'Anulada', 5 => 'Fallecido' }
                UserActivityLog.create!(user: @current_user, action: 'update_emergency_status', description: "Cambió estado de emergencia ##{@emergency.id} de '#{status_labels[old_status]}' a '#{status_labels[@emergency.status]}' del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
            else
                UserActivityLog.create!(user: @current_user, action: 'update_emergency', description: "Editó emergencia ##{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
            end
            render json: ::EmergencyRepresenter.new(@emergency), status: :ok
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def emergency_params
        params.permit(:patient_id, :ingress_date, :status, :medical_exit, :diagnostic, :treatment, :observations, :transfer, :classification, :cause_of_death, :egress_at, :reason_for_consultation, :current_illness, :discharge_note, :admission_note)
    end

    def assign_doctors(emergency)
        return unless params[:doctors].present?
        emergency.emergency_doctors.destroy_all
        params[:doctors].each_with_index do |doc, idx|
            emergency.emergency_doctors.create!(
                doctor_id: doc[:id],
                primary: idx.zero?
            )
        end
    end

    def set_emergency
        @emergency = Emergency.find(params[:id])
    end
end
