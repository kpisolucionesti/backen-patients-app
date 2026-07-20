class DirectAdmissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize!('hospitalizacion.edit')

    ActiveRecord::Base.transaction do
      patient = find_or_create_patient!

      if Emergency.where(patient_id: patient.id, status: [1, 3]).exists?
        render json: { error: 'El paciente ya tiene una emergencia activa' }, status: :unprocessable_entity
        return
      end
      if Emergency.joins(:hospitalization)
                  .where(emergencies: { patient_id: patient.id })
                  .where(hospitalizations: { status: 'active' }).exists?
        render json: { error: 'El paciente ya tiene una hospitalización activa' }, status: :unprocessable_entity
        return
      end

      emergency = Emergency.new(
        patient: patient,
        status: 3,
        transfer: 'Hospitalizacion',
        ingress_date: Time.current,
        diagnostic: params[:emergency][:diagnostic],
        treatment: params[:emergency][:treatment],
        classification: params[:emergency][:classification],
        reason_for_consultation: params[:emergency][:reason_for_consultation],
        current_illness: params[:emergency][:current_illness],
        admission_note: params[:emergency][:admission_note],
        created_by: @current_user
      )
      emergency.save!

      if params[:doctors].present?
        params[:doctors].each_with_index do |doc, idx|
          emergency.emergency_doctors.create!(
            doctor_id: doc[:id],
            primary: idx.zero?
          )
        end
      end

      hospitalization = emergency.build_hospitalization(
        room_id: params[:hospitalization][:room_id],
        attending_doctor_id: params[:hospitalization][:attending_doctor_id],
        admission_diagnosis: params[:hospitalization][:admission_diagnosis],
        admission_date: params.dig(:hospitalization, :admission_date) || Time.current,
        status: 'active'
      )
      hospitalization.save!

      if hospitalization.room_id
        Room.where(id: hospitalization.room_id).update_all(patient_id: patient.id)
      end

      UserActivityLog.create!(
        user: @current_user,
        action: 'direct_admission',
        description: "Ingreso directo a hospitalización: emergencia ##{emergency.id} paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})"
      )

      render json: ::EmergencyRepresenter.new(emergency), status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def find_or_create_patient!
    if params[:patient_id].present?
      patient = Patient.find(params[:patient_id])
      raise ActiveRecord::RecordNotFound, 'Paciente no encontrado' unless patient
      raise 'Paciente fallecido' if patient.disabled?
      patient
    elsif params[:patient].present?
      if params[:patient][:ci].present?
        existing = Patient.find_by(ci: params[:patient][:ci])
        return existing if existing && !existing.disabled?
      end
      Patient.create!(
        ci: params[:patient][:ci],
        name: params[:patient][:name],
        lastname: params[:patient][:lastname],
        gender: params[:patient][:gender],
        birthday: params[:patient][:birthday],
        medical_history_number: params[:patient][:medical_history_number] || params[:patient][:ci],
        created_by: @current_user
      )
    else
      raise 'Debe proporcionar patient_id o datos del paciente'
    end
  end
end
