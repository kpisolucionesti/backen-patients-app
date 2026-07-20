class SurgeriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospitalization, except: [:search]

  def search
    authorize!('hospitalizacion.view')
    surgeries = Surgery.includes(hospitalization: { emergency: :patient })
                       .order(surgery_date: :desc)

    if params[:q].present?
      q = "%#{params[:q]}%"
      patient_ids = Patient.where("name ILIKE ? OR lastname ILIKE ? OR ci ILIKE ?", q, q, q).pluck(:id)
      hospitalization_ids = Hospitalization.joins(:emergency)
                                            .where(emergencies: { patient_id: patient_ids })
                                            .pluck(:id)
      surgeries = surgeries.where(hospitalization_id: hospitalization_ids)
    end

    if params[:from].present?
      surgeries = surgeries.where("surgery_date >= ?", params[:from])
    end

    if params[:to].present?
      surgeries = surgeries.where("surgery_date <= ?", params[:to])
    end

    total = surgeries.count
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 50).to_i
    surgeries = surgeries.limit(per_page).offset((page - 1) * per_page)

    render json: {
      data: surgeries.map { |s| serialize_surgery(s) },
      total: total
    }, status: :ok
  end

  def index
    authorize!('hospitalizacion.view')
    surgeries = @hospitalization.surgeries.order(surgery_date: :desc)
    render json: ::SurgeryRepresenter.for_collection.new(surgeries), status: :ok
  end

  def create
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.build(surgery_params)
    if surgery.save
      render json: ::SurgeryRepresenter.new(surgery), status: :created
    else
      render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.find(params[:id])
    if surgery.update(surgery_params)
      render json: ::SurgeryRepresenter.new(surgery), status: :ok
    else
      render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.find(params[:id])
    surgery.destroy!
    head :no_content
  end

  private

  def set_hospitalization
    @hospitalization = Hospitalization.find(params[:hospitalization_id])
  end

  def surgery_params
    params.permit(:surgery_type, :description, :surgeon_name, :surgery_date, :status,
                  :preop_notes, :postop_notes, :result, :preanesthetic_evaluation,
                  :area_id, :patient_id, :scheduled_start_time, :scheduled_end_time,
                  :anesthesiologist, :anesthesia_type,
                  team_members_attributes: [:id, :doctor_id, :role, :_destroy])
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
      status: surgery.status,
      preanesthetic_evaluation: surgery.preanesthetic_evaluation,
      preop_notes: surgery.preop_notes,
      postop_notes: surgery.postop_notes,
      result: surgery.result,
      area_id: surgery.area_id,
      anesthesiologist: surgery.anesthesiologist,
      anesthesia_type: surgery.anesthesia_type,
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
end
