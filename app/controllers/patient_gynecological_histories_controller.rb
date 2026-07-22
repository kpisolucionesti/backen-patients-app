class PatientGynecologicalHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('pacientes.view')
    records = @patient.gynecological_histories.order(fecha_ultimo_evento: :desc, created_at: :desc)
    render json: ::PatientGynecologicalHistoryRepresenter.for_collection.new(records), status: :ok
  end

  def create
    authorize!('pacientes.edit')
    record = @patient.gynecological_histories.new(gynecological_history_params)
    if record.save
      UserActivityLog.create!(user: @current_user, action: 'create_gynecological_history', description: "Creó historia ginecobstétrica '#{record.evento}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientGynecologicalHistoryRepresenter.new(record), status: :created
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('pacientes.edit')
    record = @patient.gynecological_histories.find(params[:id])
    if record.update(gynecological_history_params)
      UserActivityLog.create!(user: @current_user, action: 'edit_gynecological_history', description: "Editó historia ginecobstétrica '#{record.evento}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientGynecologicalHistoryRepresenter.new(record), status: :ok
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('pacientes.edit')
    record = @patient.gynecological_histories.find(params[:id])
    UserActivityLog.create!(user: @current_user, action: 'delete_gynecological_history', description: "Eliminó historia ginecobstétrica '#{record.evento}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
    record.destroy!
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def gynecological_history_params
    params.permit(:evento, :fecha_ultimo_evento, :observaciones)
  end
end
