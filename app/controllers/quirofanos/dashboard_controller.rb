module Quirofanos
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def schedule
      authorize!('quirofano.view')
      date = params[:date] ? Date.parse(params[:date]) : Date.current

      surgeries = Surgery.where(surgery_date: date.all_day)
                         .includes(:hospitalization, :patient, :area, :surgery_team_members)
                         .order(:scheduled_start_time)

      areas = Area.where(room_type: 'quirofano').order(:name)

      render json: {
        date: date,
        areas: ::AreaRepresenter.for_collection.new(areas),
        surgeries: surgeries.map { |s| serialize_surgery(s) }
      }, status: :ok
    end

    def weekly
      authorize!('quirofano.view')
      start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.current.beginning_of_week
      end_date = params[:end_date] ? Date.parse(params[:end_date]) : start_date.end_of_week

      surgeries = Surgery.where(surgery_date: start_date.beginning_of_day..end_date.end_of_day)
                         .includes(:hospitalization, :patient, :area, :surgery_team_members)
                         .order(:scheduled_start_time)

      render json: {
        start_date: start_date,
        end_date: end_date,
        surgeries: surgeries.map { |s| serialize_surgery(s) }
      }, status: :ok
    end

    private

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
        anesthesiologist: surgery.anesthesiologist,
        anesthesia_type: surgery.anesthesia_type,
        preanesthetic_evaluation: surgery.preanesthetic_evaluation,
        preop_notes: surgery.preop_notes,
        postop_notes: surgery.postop_notes,
        result: surgery.result,
        ambulatory: surgery.ambulatory?,
        cancellation_reason: surgery.cancellation_reason,
        area: surgery.area ? { id: surgery.area.id, name: surgery.area.name } : nil,
        team_members: surgery.surgery_team_members.map { |m|
          {
            id: m.id,
            role: m.role,
            doctor: { id: m.doctor.id, name: m.doctor.name, speciality: m.doctor.speciality }
          }
        },
        patient: patient ? {
          id: patient.id,
          name: patient.name,
          lastname: patient.lastname,
          ci: patient.ci
        } : nil
      }
    end
  end
end
