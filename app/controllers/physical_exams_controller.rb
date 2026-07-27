class PhysicalExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency

  EXAM_FIELDS = %w[cabeza ojo cuello orl torax cardiovascular abdomen genitales extremidades neurologico].freeze

  def index
    authorize!('emergencia.view')
    doctor_id = @current_user.doctor_id
    exam = @emergency.physical_exams.find_or_initialize_by(doctor_id: doctor_id) if doctor_id
    exam ||= @emergency.physical_exams.first
    render json: exam || {}, status: :ok
  end

  def create
    authorize!('emergencia.edit')
    doctor_id = @current_user.doctor_id
    exam = @emergency.physical_exams.find_or_initialize_by(doctor_id: doctor_id)
    exam.assign_attributes(exam_params)
    exam.doctor_id = doctor_id if doctor_id
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
    doctor_id = @current_user.doctor_id
    exam = @emergency.physical_exams.find_by(doctor_id: doctor_id)
    unless exam
      render json: { error: 'Examen no encontrado' }, status: :not_found
      return
    end
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
