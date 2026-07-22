class PatientFamilyAntecedentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('pacientes.view')
    records = @patient.family_antecedents.order(created_at: :desc)
    render json: ::PatientFamilyAntecedentRepresenter.for_collection.new(records), status: :ok
  end

  def create
    authorize!('pacientes.edit')
    record = @patient.family_antecedents.new(family_antecedent_params)
    if record.save
      UserActivityLog.create!(user: @current_user, action: 'create_family_antecedent', description: "Creó antecedente familiar '#{record.patologia}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientFamilyAntecedentRepresenter.new(record), status: :created
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('pacientes.edit')
    record = @patient.family_antecedents.find(params[:id])
    if record.update(family_antecedent_params)
      UserActivityLog.create!(user: @current_user, action: 'edit_family_antecedent', description: "Editó antecedente familiar '#{record.patologia}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientFamilyAntecedentRepresenter.new(record), status: :ok
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('pacientes.edit')
    record = @patient.family_antecedents.find(params[:id])
    UserActivityLog.create!(user: @current_user, action: 'delete_family_antecedent', description: "Eliminó antecedente familiar '#{record.patologia}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
    record.destroy!
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def family_antecedent_params
    params.permit(:patologia, :parentesco, :valor)
  end
end
