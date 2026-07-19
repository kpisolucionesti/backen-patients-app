class VitalSignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency

  def index
    authorize!('emergencia.view')
    signs = @emergency.vital_signs.includes(:recorded_by).order(recorded_at: :desc)
    render json: ::VitalSignRepresenter.for_collection.new(signs), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    sign = @emergency.vital_signs.new(vital_sign_params)
    sign.recorded_by = @current_user
    sign.recorded_at ||= Time.current
    if sign.save
      patient = @emergency.patient
      UserActivityLog.create!(user: @current_user, action: 'create_vital_signs', description: "Registró signos vitales para emergencia #{@emergency.id} del paciente #{patient.name} #{patient.lastname} (CI: #{patient.ci})")
      render json: ::VitalSignRepresenter.new(sign), status: :created
    else
      render json: { error: sign.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def vital_sign_params
    params.permit(:systolic_bp, :diastolic_bp, :heart_rate, :respiratory_rate, :temperature, :oxygen_saturation, :glucose, :height, :weight, :bmi, :recorded_at)
  end
end
