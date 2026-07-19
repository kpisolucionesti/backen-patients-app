class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :specialty
  belongs_to :created_by, class_name: 'User'
  has_one :appointment_record, dependent: :destroy

  validates :appointment_date, presence: true
  validates :status, inclusion: { in: %w[scheduled confirmed in_consultation completed cancelled no_show] }

  before_create :assign_turn_number
  before_create :calculate_end_time

  scope :for_date, ->(date) { where(appointment_date: date) }
  scope :for_doctor, ->(doctor_id) { where(doctor_id: doctor_id) }
  scope :for_patient, ->(patient_id) { where(patient_id: patient_id) }
  scope :by_status, ->(status) { where(status: status) }
  scope :ordered, -> { order(:appointment_date, :start_time, :turn_number) }

  STATUS_OPTIONS = {
    'scheduled' => 'Agendada',
    'confirmed' => 'Confirmada',
    'in_consultation' => 'En consulta',
    'completed' => 'Completada',
    'cancelled' => 'Cancelada',
    'no_show' => 'No asistió'
  }.freeze

  def status_label
    STATUS_OPTIONS[status] || status
  end

  private

  def assign_turn_number
    max_turn = Appointment.where(doctor_id: doctor_id, appointment_date: appointment_date)
                          .maximum(:turn_number) || 0
    self.turn_number = max_turn + 1
  end

  def calculate_end_time
    return unless start_time && doctor

    schedule = doctor.schedules.active
                     .where('start_time <= ? AND end_time > ?', start_time, start_time)
                     .order(:day_of_week)
                     .first
    duration = schedule&.appointment_duration || 30
    self.end_time = (start_time + duration.minutes).strftime('%H:%M:%S')
  end
end
