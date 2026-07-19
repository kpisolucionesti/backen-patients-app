class AppointmentDisplay < ApplicationRecord
  belongs_to :specialty, optional: true

  validates :name, presence: true
  validates :public_id, presence: true, uniqueness: true

  before_validation :generate_public_id, on: :create

  scope :active, -> { where(is_active: true) }

  def queue
    today = Date.current
    scope = Appointment.for_date(today)
                       .where.not(status: %w[cancelled no_show])
                       .ordered
                       .includes(:patient, :doctor, :specialty)

    scope = scope.where(specialty_id: specialty_id) if specialty_id.present?

    doctors_with_appointments = scope.pluck(:doctor_id).uniq
    doctors = Doctor.where(id: doctors_with_appointments).includes(:specialty, :schedules)

    doctors.map do |doctor|
      doctor_apps = scope.select { |a| a.doctor_id == doctor.id }
      current = doctor_apps.find { |a| a.status == 'in_consultation' }
      confirmed_or_scheduled = doctor_apps.select { |a| %w[scheduled confirmed].include?(a.status) }
      waiting = confirmed_or_scheduled.map.with_index do |a, idx|
        {
          id: a.id,
          turn_number: a.turn_number,
          patient_name: "#{a.patient&.name} #{a.patient&.lastname}",
          patients_ahead: idx
        }
      end

      {
        doctor: {
          id: doctor.id,
          name: doctor.name,
          specialty: doctor.specialty&.name
        },
        current: current ? {
          id: current.id,
          turn_number: current.turn_number,
          patient_name: "#{current.patient&.name} #{current.patient&.lastname}",
          called_since: current.updated_at
        } : nil,
        waiting: waiting
      }
    end
  end

  private

  def generate_public_id
    self.public_id ||= SecureRandom.hex(8)
  end
end
