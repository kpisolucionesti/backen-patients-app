class PhysicalExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency

  EXAM_FIELDS = %w[cabeza ojo cuello orl torax cardiovascular abdomen genitales extremidades neurologico].freeze

  def index
    authorize!('emergencia.view')
    exam = @emergency.physical_exam
    render json: exam || {}, status: :ok
  end

  def create
    authorize!('emergencia.edit')
    exam = @emergency.build_physical_exam(exam_params)
    if exam.save
      UserActivityLog.create!(
        user: @current_user,
        action: 'create_physical_exam',
        description: "Creó examen físico para emergencia ##{@emergency.id} del paciente #{@emergency.patient.name} #{@emergency.patient.lastname}"
      )
      render json: exam, status: :created
    else
      render json: { error: exam.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    exam = @emergency.physical_exam
    if exam.update(exam_params)
      UserActivityLog.create!(
        user: @current_user,
        action: 'update_physical_exam',
        description: "Actualizó examen físico para emergencia ##{@emergency.id} del paciente #{@emergency.patient.name} #{@emergency.patient.lastname}"
      )
      render json: exam, status: :ok
    else
      render json: { error: exam.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def exam_params
    params.permit(EXAM_FIELDS)
  end
end
