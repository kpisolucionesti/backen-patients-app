class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:show, :update, :complete]

  def index
    authorize!('citas.view')
    appointments = Appointment.ordered.includes(:patient, :doctor, :specialty, :created_by)

    appointments = appointments.for_date(params[:date]) if params[:date].present?
    appointments = appointments.for_doctor(params[:doctor_id]) if params[:doctor_id].present?
    appointments = appointments.for_patient(params[:patient_id]) if params[:patient_id].present?
    appointments = appointments.by_status(params[:status]) if params[:status].present?

    if params[:start_date].present? && params[:end_date].present?
      appointments = appointments.where(appointment_date: params[:start_date]..params[:end_date])
    end

    appointments = appointments.where(doctor_id: Doctor.where(specialty_id: params[:specialty_id]).select(:id)) if params[:specialty_id].present?

    render json: ::AppointmentRepresenter.for_collection.new(appointments), status: :ok
  end

  def show
    authorize!('citas.view')
    render json: ::AppointmentRepresenter.new(@appointment), status: :ok
  end

  def create
    authorize!('citas.create')
    appointment = Appointment.new(appointment_params)
    appointment.created_by = @current_user

    if appointment.doctor && appointment.appointment_date
      schedule = appointment.doctor.schedules.active
                            .where(day_of_week: appointment.appointment_date.wday)
                            .order(:start_time)
                            .first

      if schedule&.max_patients.to_i > 0
        existing = Appointment.for_doctor(appointment.doctor_id)
                              .for_date(appointment.appointment_date)
                              .where.not(status: %w[cancelled no_show])
                              .count
        if existing >= schedule.max_patients
          return render json: { error: "El médico ha alcanzado el límite de pacientes para este día" }, status: :unprocessable_entity
        end
      end
    end

    appointment.save!
    UserActivityLog.create!(user: @current_user, action: 'create_appointment', description: "Creó cita para paciente ##{appointment.patient_id}")
    render json: ::AppointmentRepresenter.new(appointment), status: :created
  end

  def update
    authorize!('citas.edit')
    @appointment.update!(appointment_params)
    UserActivityLog.create!(user: @current_user, action: 'update_appointment', description: "Actualizó cita ##{@appointment.id}")
    render json: ::AppointmentRepresenter.new(@appointment), status: :ok
  end

  def complete
    authorize!('citas.attend')
    if @appointment.status == 'in_consultation'
      @appointment.update!(status: 'completed')
      UserActivityLog.create!(user: @current_user, action: 'complete_appointment', description: "Completó cita ##{@appointment.id}")
    end
    render json: ::AppointmentRepresenter.new(@appointment), status: :ok
  end

  def available_slots
    authorize!('citas.view')
    doctor = Doctor.find(params[:doctor_id])
    date = Date.parse(params[:date])

    schedule_blocks = doctor.schedules.active.where(day_of_week: date.wday).ordered
    existing = Appointment.for_doctor(doctor.id).for_date(date)
                          .where.not(status: %w[cancelled no_show])
                          .pluck(:start_time, :end_time)

    slots = []
    schedule_blocks.each do |block|
      current = block.start_time
      while current + block.appointment_duration.minutes <= block.end_time
        unless existing.any? { |s, e| current >= s && current < e }
          slots << current.strftime('%H:%M')
        end
        current += block.appointment_duration.minutes
      end
    end

    render json: slots, status: :ok
  end

  private

  def appointment_params
    params.permit(:patient_id, :doctor_id, :specialty_id, :appointment_date, :start_time, :end_time, :status, :notes)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
end
