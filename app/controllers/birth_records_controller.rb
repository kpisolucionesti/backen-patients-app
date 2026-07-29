class BirthRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mother_patient
  before_action :set_mother_emergency

  def create
    babies_params = params.require(:babies)
    birth_date = params[:birth_date].presence || Time.current
    gestational_age = params[:gestational_age_weeks]
    doctor_id = params[:doctor_id].presence

    doctor = Doctor.find_by(id: doctor_id) if doctor_id

    records = babies_params.map.with_index(1) do |baby, index|
      ActiveRecord::Base.transaction do
        baby_patient = create_baby_patient(baby)
        baby_emergency = create_baby_emergency(baby_patient)
        baby_hospitalization = create_baby_hospitalization(baby_emergency, doctor)
        assign_primary_doctor(baby_emergency, doctor) if doctor

        BirthRecord.create!(
          mother_patient: @mother_patient,
          baby_patient: baby_patient,
          mother_emergency: @mother_emergency,
          baby_emergency: baby_emergency,
          doctor: doctor,
          birth_date: birth_date,
          birth_type: baby[:birth_type],
          gestational_age_weeks: gestational_age,
          birth_weight_grams: baby[:weight_grams].presence,
          apgar_1min: baby[:apgar_1min].presence,
          apgar_5min: baby[:apgar_5min].presence,
          birth_order: index,
          complications: baby[:complications].presence,
          observations: baby[:observations].presence
        )
      end
    end

    render json: records, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_mother_patient
    @mother_patient = Patient.find(params[:mother_patient_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Paciente madre no encontrado' }, status: :not_found
  end

  def set_mother_emergency
    @mother_emergency = Emergency.find(params[:mother_emergency_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Emergencia no encontrada' }, status: :not_found
  end

  def create_baby_patient(baby)
    baby_name = baby[:name].presence || "RN de #{@mother_patient.lastname}"
    hc = generate_hc_number

    Patient.create!(
      name: baby_name,
      lastname: @mother_patient.lastname,
      birthday: params[:birth_date].presence&.to_date || Date.current,
      gender: baby[:gender] || 'O',
      patient_category: 'recien_nacido',
      medical_history_number: hc,
      mother: @mother_patient,
      representante: "#{@mother_patient.name} #{@mother_patient.lastname}",
      representante_ci: @mother_patient.ci,
      created_by: @current_user
    )
  end

  def create_baby_emergency(baby_patient)
    Emergency.create!(
      patient: baby_patient,
      status: Emergency::STATUS_INGRESADO,
      classification: 'green',
      ingress_date: Date.current,
      reason_for_consultation: 'Recién nacido — Ingreso a hospitalización',
      observations: "Registrado desde parto.\nMadre: #{@mother_patient.name} #{@mother_patient.lastname} (CI: #{@mother_patient.ci})",
      created_by: @current_user
    )
  end

  def create_baby_hospitalization(baby_emergency, doctor)
    Hospitalization.create!(
      emergency: baby_emergency,
      admission_date: Time.current,
      status: 'active',
      admitting_doctor: doctor,
      attending_doctor: doctor,
      admission_diagnosis: 'Recién nacido — Observación / Cuidados iniciales'
    )
  end

  def assign_primary_doctor(baby_emergency, doctor)
    baby_emergency.emergency_doctors.create!(doctor: doctor, primary: true)
  end

  def generate_hc_number
    loop do
      hc = "HC-#{Date.current.year}-#{SecureRandom.random_number(10**5).to_s.rjust(5, '0')}"
      break hc unless Patient.exists?(medical_history_number: hc)
    end
  end
end
