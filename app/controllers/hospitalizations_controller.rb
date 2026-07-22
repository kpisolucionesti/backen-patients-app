class HospitalizationsController < ApplicationController
  before_action :authenticate_user!

  def historical
    authorize!('hospitalizacion.view')
    hospitalizations = Hospitalization.where(status: 'discharged')
                                      .includes(:admitting_doctor, :attending_doctor, :room, emergency: [:patient, :doctors])
                                      .order(discharge_date: :desc)

    if params[:patient_id].present?
      hospitalizations = hospitalizations.where(emergencies: { patient_id: params[:patient_id] })
    elsif params[:q].present?
      q = "%#{params[:q]}%"
      patient_ids = Patient.where("name ILIKE ? OR lastname ILIKE ? OR ci ILIKE ?", q, q, q).pluck(:id)
      hospitalizations = hospitalizations.where(emergencies: { patient_id: patient_ids })
    end

    total = hospitalizations.count
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 50).to_i
    hospitalizations = hospitalizations.limit(per_page).offset((page - 1) * per_page)

    render json: {
      data: ::HospitalizationRepresenter.for_collection.new(hospitalizations),
      total: total
    }, status: :ok
  end

  def show
    authorize!('hospitalizacion.view')
    hospitalization = if params[:emergency_id]
      Hospitalization.includes(:admitting_doctor, :attending_doctor, :room, :surgeries, emergency: [:patient, :doctors]).find_by!(emergency_id: params[:emergency_id])
    else
      Hospitalization.includes(:admitting_doctor, :attending_doctor, :room, :surgeries, emergency: [:patient, :doctors]).find(params[:id])
    end
    render json: ::HospitalizationRepresenter.new(hospitalization), status: :ok
  end

  def create
    authorize!('hospitalizacion.edit')
    emergency = Emergency.find(params[:emergency_id])

    if emergency.hospitalization
      return render json: { error: 'El paciente ya tiene una hospitalización activa' }, status: :unprocessable_entity
    end

    missing = []
    missing << 'Diagnóstico' if emergency.diagnostic.blank?
    missing << 'Plan' if emergency.treatment.blank?
    missing << 'Clasificación' if emergency.classification.blank?
    missing << 'Motivo de Consulta' if emergency.reason_for_consultation.blank?
    missing << 'Enfermedad Actual' if emergency.current_illness.blank?
    missing << 'Médico Tratante' if emergency.primary_doctor.nil?

    if missing.any?
      return render json: { error: "Debe completar antes de ingresar: #{missing.join(', ')}" }, status: :unprocessable_entity
    end

    hospitalization = emergency.build_hospitalization(hospitalization_params)
    hospitalization.admission_date ||= Time.current

    if hospitalization.save
      render json: ::HospitalizationRepresenter.new(hospitalization), status: :created
    else
      render json: { error: hospitalization.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    hospitalization = Hospitalization.find_by!(emergency_id: params[:emergency_id])
    if hospitalization.update(hospitalization_params)
      render json: ::HospitalizationRepresenter.new(hospitalization), status: :ok
    else
      render json: { error: hospitalization.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def discharge
    authorize!('hospitalizacion.edit')
    hospitalization = Hospitalization.find_by!(emergency_id: params[:emergency_id])
    if hospitalization.discharge_date.present?
      return render json: { error: 'El paciente ya fue dado de alta' }, status: :unprocessable_entity
    end

    if hospitalization.update(
      status: 'discharged',
      discharge_date: Time.current,
      discharge_summary: params[:discharge_summary],
      discharge_diagnosis: params[:discharge_diagnosis]
    )
      hospitalization.emergency.update!(status: 2) if hospitalization.emergency.status == 3

      patient = hospitalization.emergency&.patient
      if patient
        Notification.create!(
          notification_type: 'hospitalization_discharge',
          title: "Alta de Hospitalización — #{patient.name} #{patient.lastname}",
          message: "#{patient.name} #{patient.lastname} fue dado de alta de hospitalización",
          link: '/patients/atencion?tab=historial',
          emergency_id: hospitalization.emergency_id
        )
      end
      render json: ::HospitalizationRepresenter.new(hospitalization), status: :ok
    else
      render json: { error: hospitalization.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def census
    authorize!('hospitalizacion.view')

    recent_cutoff = 7.days.ago
    Emergency.where(status: 3, transfer: 'Hospitalizacion')
             .where.not(id: Hospitalization.select(:emergency_id))
             .where("ingress_date >= ? OR created_at >= ?", recent_cutoff, recent_cutoff)
             .limit(100)
             .each do |emergency|
      hospitalization = emergency.build_hospitalization(
        admission_date: Time.current,
        admission_diagnosis: emergency.diagnostic,
        status: 'active'
      )
      hospitalization.save(validate: false) rescue nil
    end

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 50).to_i
    hospitalizations = Hospitalization.active.includes(:admitting_doctor, :attending_doctor, :room, :surgeries, emergency: [:patient, :doctors, :vital_signs])
                                     .order(admission_date: :desc)
                                     .limit(per_page).offset((page - 1) * per_page)

    render json: {
      data: ::HospitalizationRepresenter.for_collection.new(hospitalizations),
      total: Hospitalization.active.count
    }, status: :ok
  end

  private

  def hospitalization_params
    params.permit(:room_id, :admitting_doctor_id, :attending_doctor_id, :admission_diagnosis, :discharge_diagnosis, :discharge_summary, :admission_date, :discharge_date, :status)
  end
end
