class EvaluationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency
  before_action :set_evaluation, only: [:update, :destroy]

  def index
    authorize!('emergencia.view')
    evaluations = @emergency.evaluations.includes(:doctor, :created_by).order(created_at: :desc)
    render json: ::EvaluationRepresenter.for_collection.new(evaluations), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    evaluation = @emergency.evaluations.new(evaluation_params)
    evaluation.created_by = @current_user
    if evaluation.save
      patient = @emergency.patient
      UserActivityLog.create!(user: @current_user, action: 'create_evaluation', description: "Creó evaluación para emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
      render json: ::EvaluationRepresenter.new(evaluation), status: :created
    else
      render json: { error: evaluation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    if @evaluation.doctor_id != @current_user.doctor_id
      render json: { error: 'Solo el médico que creó la evaluación puede editarla' }, status: :forbidden
      return
    end
    if @evaluation.update(evaluation_params)
      patient = @emergency.patient
      UserActivityLog.create!(user: @current_user, action: 'edit_evaluation', description: "Editó evaluación de emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
      render json: ::EvaluationRepresenter.new(@evaluation), status: :ok
    else
      render json: { error: @evaluation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    if @evaluation.doctor_id != @current_user.doctor_id
      render json: { error: 'Solo el médico que creó la evaluación puede eliminarla' }, status: :forbidden
      return
    end
    patient = @emergency.patient
    UserActivityLog.create!(user: @current_user, action: 'delete_evaluation', description: "Eliminó evaluación de emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
    @evaluation.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def set_evaluation
    @evaluation = @emergency.evaluations.find(params[:id])
  end

  def evaluation_params
    params.permit(:doctor_id, :diagnostic_impression, :plan)
  end
end
