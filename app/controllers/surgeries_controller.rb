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
    surgeries = surgeries.page(page).per(per_page)

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
    params.permit(:surgery_type, :description, :surgeon_name, :surgery_date, :status, :preop_notes, :postop_notes, :result)
  end

  def serialize_surgery(surgery)
    patient = surgery.hospitalization&.emergency&.patient
    {
      id: surgery.id,
      hospitalization_id: surgery.hospitalization_id,
      surgery_type: surgery.surgery_type,
      description: surgery.description,
      surgeon_name: surgery.surgeon_name,
      surgery_date: surgery.surgery_date,
      status: surgery.status,
      result: surgery.result,
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
