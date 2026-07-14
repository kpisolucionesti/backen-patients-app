class EmergenciesController < ApplicationController
    before_action :set_emergency, only: [:update, :destroy, :show]

    def index
        emergencies = Emergency.includes(:patient, :doctors).all
        render json: ::EmergencyRepresenter.for_collection.new(emergencies), status: :ok
    end

    def show
        render json: ::EmergencyRepresenter.new(@emergency), status: :ok
    end

    def create
        ActiveRecord::Base.transaction do
            emergency = Emergency.new(emergency_params)
            emergency.save!
            assign_doctors(emergency)
            render json: ::EmergencyRepresenter.new(emergency), status: :created
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
        ActiveRecord::Base.transaction do
            @emergency.update!(emergency_params)
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
