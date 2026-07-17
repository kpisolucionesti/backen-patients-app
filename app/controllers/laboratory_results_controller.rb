class LaboratoryResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency

  def index
    authorize!('emergencia.view')
    results = @emergency.laboratory_results.includes(:lab_result_values).order(result_date: :desc)
    render json: results.as_json(include: :lab_result_values), status: :ok
  end

  def show
    authorize!('emergencia.view')
    result = @emergency.laboratory_results.find(params[:id])
    render json: result.as_json(include: :lab_result_values), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    result = @emergency.laboratory_results.new(result_params)
    if result.save
      UserActivityLog.create!(
        user: @current_user,
        action: 'create_laboratory_result',
        description: "Creó resultado de laboratorio para emergencia ##{@emergency.id} del paciente #{@emergency.patient.name} #{@emergency.patient.lastname}"
      )
      render json: result.as_json(include: :lab_result_values), status: :created
    else
      render json: { error: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    result = @emergency.laboratory_results.find(params[:id])
    if result.update(result_params)
      UserActivityLog.create!(
        user: @current_user,
        action: 'update_laboratory_result',
        description: "Actualizó resultado de laboratorio para emergencia ##{@emergency.id} del paciente #{@emergency.patient.name} #{@emergency.patient.lastname}"
      )
      render json: result.as_json(include: :lab_result_values), status: :ok
    else
      render json: { error: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    result = @emergency.laboratory_results.find(params[:id])
    UserActivityLog.create!(
      user: @current_user,
      action: 'delete_laboratory_result',
      description: "Eliminó resultado de laboratorio para emergencia ##{@emergency.id} del paciente #{@emergency.patient.name} #{@emergency.patient.lastname}"
    )
    result.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def result_params
    params.permit(:result_date, :notes, lab_result_values_attributes: [:id, :parameter_name, :value, :unit, :reference_range, :_destroy])
  end
end
