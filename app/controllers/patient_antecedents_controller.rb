class PatientAntecedentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('pacientes.view')
    antecedents = @patient.antecedents.order(diagnosed_at: :desc, created_at: :desc)
    render json: ::PatientAntecedentRepresenter.for_collection.new(antecedents), status: :ok
  end

  def create
    authorize!('pacientes.edit')
    antecedent = @patient.antecedents.new(antecedent_params)
    if antecedent.save
      UserActivityLog.create!(user: @current_user, action: 'create_antecedent', description: "Creó antecedente '#{antecedent.condition_type}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientAntecedentRepresenter.new(antecedent), status: :created
    else
      render json: { error: antecedent.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('pacientes.edit')
    antecedent = @patient.antecedents.find(params[:id])
    if antecedent.update(antecedent_params)
      UserActivityLog.create!(user: @current_user, action: 'edit_antecedent', description: "Editó antecedente '#{antecedent.condition_type}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientAntecedentRepresenter.new(antecedent), status: :ok
    else
      render json: { error: antecedent.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('pacientes.edit')
    antecedent = @patient.antecedents.find(params[:id])
    UserActivityLog.create!(user: @current_user, action: 'delete_antecedent', description: "Eliminó antecedente '#{antecedent.condition_type}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
    antecedent.destroy!
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def antecedent_params
    params.permit(:condition_type, :description, :diagnosed_at, :medication, :notes)
  end
end
