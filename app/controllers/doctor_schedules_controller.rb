class DoctorSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor

  def show
    authorize!('agenda.edit')
    schedules = @doctor.schedules.ordered
    render json: ::DoctorScheduleRepresenter.for_collection.new(schedules), status: :ok
  end

  def update
    authorize!('agenda.edit')
    schedules_params = params.permit(schedules: [:id, :day_of_week, :start_time, :end_time, :appointment_duration, :appointment_mode, :max_patients, :is_active])
    new_schedules = schedules_params[:schedules] || []

    ActiveRecord::Base.transaction do
      existing_ids = new_schedules.select { |s| s[:id].present? }.map { |s| s[:id].to_i }
      @doctor.schedules.where.not(id: existing_ids).destroy_all

      new_schedules.each do |sched|
        if sched[:id].present?
          record = @doctor.schedules.find(sched[:id])
          record.update!(sched.permit(:day_of_week, :start_time, :end_time, :appointment_duration, :appointment_mode, :max_patients, :is_active))
        else
          @doctor.schedules.create!(sched.permit(:day_of_week, :start_time, :end_time, :appointment_duration, :appointment_mode, :max_patients, :is_active))
        end
      end
    end

    schedules = @doctor.schedules.reload.ordered
    UserActivityLog.create!(user: @current_user, action: 'update_schedules', description: "Actualizó agenda del médico '#{@doctor.name}'")
    render json: ::DoctorScheduleRepresenter.for_collection.new(schedules), status: :ok
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end
end
