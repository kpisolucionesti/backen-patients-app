class EmergenciesController < ApplicationController
    before_action :authenticate_user!
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
        ActiveRecord::Base.transaction do
            emergency = Emergency.new(emergency_params)
            emergency.created_by = @current_user
            emergency.save!
            assign_doctors(emergency)
            render json: ::EmergencyRepresenter.new(emergency), status: :created
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
        authorize!('emergencia.edit')
        ActiveRecord::Base.transaction do
            update_params = emergency_params
            if [2, 3].include?(update_params[:status].to_i) && !@emergency.egress_at
                update_params = update_params.merge(egress_at: Time.current)
            end
            @emergency.update!(update_params)
            assign_doctors(@emergency) if params[:doctors].present?
            render json: ::EmergencyRepresenter.new(@emergency), status: :ok
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def emergency_params
        params.permit(:patient_id, :ingress_date, :status, :medical_exit, :diagnostic, :treatment, :observations, :transfer)
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
