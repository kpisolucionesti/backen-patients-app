module Quirofanos
  class SurgeriesController < ApplicationController
    before_action :authenticate_user!

    def index
      authorize!('quirofano.view')
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 50).to_i
      surgeries = Surgery.includes(:hospitalization, :patient, :area)
                         .order(surgery_date: :desc, scheduled_start_time: :asc)
                         .limit(per_page).offset((page - 1) * per_page)
      render json: {
        data: surgeries.map { |s| serialize_surgery(s) },
        total: Surgery.count
      }, status: :ok
    end

    def create
      authorize!('quirofano.edit')
      surgery = Surgery.new(surgery_params)
      if surgery.save
        patient = surgery.patient || surgery.hospitalization&.emergency&.patient
        if patient
          Notification.create!(
            notification_type: 'surgery_scheduled',
            title: "Cirugía Programada — #{patient.name} #{patient.lastname}",
            message: "Cirugía programada para #{patient.name} #{patient.lastname}: #{surgery.surgery_type}",
            link: '/patients/atencion?tab=quirofano',
            emergency_id: surgery.hospitalization&.emergency_id
          )
        end
        update_hospitalization_status(surgery) if surgery.status == 'in_progress'
        render json: serialize_surgery(surgery), status: :created
      else
        render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def update
      authorize!('quirofano.edit')
      surgery = Surgery.find(params[:id])
      if surgery.update(surgery_params)
        render json: serialize_surgery(surgery), status: :ok
      else
        render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize!('quirofano.edit')
      surgery = Surgery.find(params[:id])
      surgery.destroy!
      head :no_content
    end

    private

    def surgery_params
      params.permit(:surgery_type, :description, :surgeon_name, :surgery_date, :status,
                    :preop_notes, :postop_notes, :result, :preanesthetic_evaluation,
                    :hospitalization_id, :area_id, :patient_id,
                    :scheduled_start_time, :scheduled_end_time,
                    :actual_start_time, :actual_end_time,
                    :anesthesiologist, :anesthesia_type, :ambulatory)
    end

    def serialize_surgery(surgery)
      patient = surgery.patient || surgery.hospitalization&.emergency&.patient
      {
        id: surgery.id,
        hospitalization_id: surgery.hospitalization_id,
        surgery_type: surgery.surgery_type,
        description: surgery.description,
        surgeon_name: surgery.surgeon_name,
        surgery_date: surgery.surgery_date,
        scheduled_start_time: surgery.scheduled_start_time,
        scheduled_end_time: surgery.scheduled_end_time,
        actual_start_time: surgery.actual_start_time,
        actual_end_time: surgery.actual_end_time,
        status: surgery.status,
        preanesthetic_evaluation: surgery.preanesthetic_evaluation,
        preop_notes: surgery.preop_notes,
        postop_notes: surgery.postop_notes,
        result: surgery.result,
        area_id: surgery.area_id,
        anesthesiologist: surgery.anesthesiologist,
        anesthesia_type: surgery.anesthesia_type,
        ambulatory: surgery.ambulatory?,
        patient: patient ? {
          id: patient.id,
          name: patient.name,
          lastname: patient.lastname,
          ci: patient.ci,
          gender: patient.gender,
          age: patient.age
        } : nil
      }
    end

    def update_hospitalization_status(surgery)
      hospitalization = surgery.hospitalization
      return unless hospitalization
      hospitalization.update(status: 'in_surgery') if hospitalization.status == 'active'
    end
  end
end
