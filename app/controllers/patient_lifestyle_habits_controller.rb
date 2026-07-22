class PatientLifestyleHabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def index
    authorize!('pacientes.view')
    records = @patient.lifestyle_habits.order(created_at: :desc)
    render json: ::PatientLifestyleHabitRepresenter.for_collection.new(records), status: :ok
  end

  def create
    authorize!('pacientes.edit')
    record = @patient.lifestyle_habits.new(lifestyle_habit_params)
    if record.save
      UserActivityLog.create!(user: @current_user, action: 'create_lifestyle_habit', description: "Creó hábito de vida '#{record.habito}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientLifestyleHabitRepresenter.new(record), status: :created
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('pacientes.edit')
    record = @patient.lifestyle_habits.find(params[:id])
    if record.update(lifestyle_habit_params)
      UserActivityLog.create!(user: @current_user, action: 'edit_lifestyle_habit', description: "Editó hábito de vida '#{record.habito}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
      render json: ::PatientLifestyleHabitRepresenter.new(record), status: :ok
    else
      render json: { error: record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('pacientes.edit')
    record = @patient.lifestyle_habits.find(params[:id])
    UserActivityLog.create!(user: @current_user, action: 'delete_lifestyle_habit', description: "Eliminó hábito de vida '#{record.habito}' del paciente #{@patient.name} #{@patient.lastname} (CI: #{@patient.ci})")
    record.destroy!
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def lifestyle_habit_params
    params.permit(:habito, :concurrencia, :observaciones)
  end
end
