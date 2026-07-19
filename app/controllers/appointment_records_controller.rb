class AppointmentRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment

  def show
    authorize!('citas.view')
    record = @appointment.appointment_record
    if record
      render json: ::AppointmentRecordRepresenter.new(record), status: :ok
    else
      render json: nil, status: :ok
    end
  end

  def create
    authorize!('citas.attend')
    if @appointment.appointment_record.present?
      return render json: { error: "Ya existe un registro clínico para esta cita" }, status: :unprocessable_entity
    end
    record = @appointment.build_appointment_record(record_params)
    record.created_by = @current_user
    record.save!
    @appointment.update!(status: 'completed') if @appointment.status != 'completed'
    UserActivityLog.create!(user: @current_user, action: 'create_appointment_record', description: "Creó registro clínico para cita ##{@appointment.id}")
    render json: ::AppointmentRecordRepresenter.new(record), status: :created
  end

  def update
    authorize!('citas.edit')
    record = @appointment.appointment_record
    if record
      record.update!(record_params)
      UserActivityLog.create!(user: @current_user, action: 'update_appointment_record', description: "Actualizó registro clínico para cita ##{@appointment.id}")
      render json: ::AppointmentRecordRepresenter.new(record), status: :ok
    else
      render json: { error: "No existe registro clínico" }, status: :not_found
    end
  end

  private

  def record_params
    params.permit(:reason_for_consultation, :current_illness, :diagnostic, :treatment, :observations, vital_signs: {})
  end

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end
end
