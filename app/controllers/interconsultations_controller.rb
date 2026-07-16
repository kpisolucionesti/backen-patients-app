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
      render json: ::InterconsultationRepresenter.new(interconsultation), status: :created
    else
      render json: { error: interconsultation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    if @interconsultation.update(interconsultation_params)
      render json: ::InterconsultationRepresenter.new(@interconsultation), status: :ok
    else
      render json: { error: @interconsultation.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
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
