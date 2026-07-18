class HospitalizationsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize!('hospitalizacion.view')
    hospitalization = Hospitalization.find_by!(emergency_id: params[:emergency_id])
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
      render json: ::HospitalizationRepresenter.new(hospitalization), status: :ok
    else
      render json: { error: hospitalization.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def census
    authorize!('hospitalizacion.view')

    Emergency.where(status: 3, transfer: 'Hospitalizacion')
             .where.not(id: Hospitalization.select(:emergency_id))
             .find_each do |emergency|
      hospitalization = emergency.build_hospitalization(
        admission_date: emergency.egress_at || emergency.created_at || Time.current,
        admission_diagnosis: emergency.diagnostic,
        status: 'active'
      )
      hospitalization.save(validate: false) rescue nil
    end

    hospitalizations = Hospitalization.active.includes(emergency: [:patient, :doctors, :vital_signs])
                                     .order(admission_date: :desc)

    render json: {
      data: ::HospitalizationRepresenter.for_collection.new(hospitalizations),
      total: hospitalizations.size
    }, status: :ok
  end

  private

  def hospitalization_params
    params.permit(:room_id, :admitting_doctor_id, :attending_doctor_id, :admission_diagnosis, :discharge_diagnosis, :discharge_summary, :admission_date, :discharge_date, :status)
  end
end
