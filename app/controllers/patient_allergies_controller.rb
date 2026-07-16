class PatientAllergiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('pacientes.view')
    allergies = @patient.allergies.order(created_at: :desc)
    render json: ::PatientAllergyRepresenter.for_collection.new(allergies), status: :ok
  end

  def create
    authorize!('pacientes.edit')
    allergy = @patient.allergies.new(allergy_params)
    if allergy.save
      UserActivityLog.create!(user: @current_user, action: 'create_allergy', description: "Creó alergia '#{allergy.allergy}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientAllergyRepresenter.new(allergy), status: :created
    else
      render json: { error: allergy.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('pacientes.edit')
    allergy = @patient.allergies.find(params[:id])
    if allergy.update(allergy_params)
      UserActivityLog.create!(user: @current_user, action: 'edit_allergy', description: "Editó alergia '#{allergy.allergy}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientAllergyRepresenter.new(allergy), status: :ok
    else
      render json: { error: allergy.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('pacientes.edit')
    allergy = @patient.allergies.find(params[:id])
    UserActivityLog.create!(user: @current_user, action: 'delete_allergy', description: "Eliminó alergia '#{allergy.allergy}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
    allergy.destroy!
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def allergy_params
    params.permit(:allergy, :severity, :notes)
  end
end
