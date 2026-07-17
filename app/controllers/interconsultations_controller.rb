class InterconsultationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency
  before_action :set_interconsultation, only: [:update, :destroy]

  def index
    authorize!('emergencia.view')
    interconsultations = @emergency.interconsultations.includes(:doctor_requested, :requested_by).order(created_at: :desc)
    render json: ::InterconsultationRepresenter.for_collection.new(interconsultations), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    interconsultation = @emergency.interconsultations.new(interconsultation_params)
    interconsultation.requested_by = @current_user
    if interconsultation.save
      patient = @emergency.patient
      UserActivityLog.create!(
        user: @current_user,
        action: 'create_interconsultation',
        description: "Creó interconsulta para emergencia ##{@emergency.id} del paciente #{patient.name} #{patient.lastname}"
      )
      render json: ::InterconsultationRepresenter.new(interconsultation), status: :created
    else
      render json: { error: interconsultation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    if @interconsultation.update(interconsultation_params)
      patient = @emergency.patient
      UserActivityLog.create!(
        user: @current_user,
        action: 'update_interconsultation',
        description: "Actualizó interconsulta para emergencia ##{@emergency.id} del paciente #{patient.name} #{patient.lastname}"
      )
      render json: ::InterconsultationRepresenter.new(@interconsultation), status: :ok
    else
      render json: { error: @interconsultation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    patient = @emergency.patient
    UserActivityLog.create!(
      user: @current_user,
      action: 'delete_interconsultation',
      description: "Eliminó interconsulta para emergencia ##{@emergency.id} del paciente #{patient.name} #{patient.lastname}"
    )
    @interconsultation.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def set_interconsultation
    @interconsultation = @emergency.interconsultations.find(params[:id])
  end

  def interconsultation_params
    params.permit(:doctor_requested_id, :reason, :observations, :status)
  end
end
