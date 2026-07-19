class DoctorScheduleRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :doctor_id
  property :day_of_week
  property :start_time
  property :end_time
  property :appointment_duration
  property :appointment_mode
  property :max_patients
  property :is_active
  property :day_name
end
