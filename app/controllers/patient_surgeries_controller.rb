class PatientSurgeriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('quirofano.view')
    surgeries = Surgery.where(patient_id: @patient.id)
                       .or(Surgery.where(hospitalization_id: Hospitalization.joins(:emergency)
                         .where(emergencies: { patient_id: @patient.id }).pluck(:id)))
                       .includes(:area, :hospitalization)
                       .order(surgery_date: :desc, scheduled_start_time: :asc)
    render json: {
      data: surgeries.map { |s| serialize_surgery(s) }
    }, status: :ok
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
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
      area: surgery.area ? { id: surgery.area.id, name: surgery.area.name } : nil,
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
      } : nil,
      team_members: surgery.surgery_team_members.includes(:doctor).map { |tm|
        {
          id: tm.id,
          role: tm.role,
          doctor: { id: tm.doctor.id, name: tm.doctor.name, speciality: tm.doctor.speciality }
        }
      }
    }
  end
end
