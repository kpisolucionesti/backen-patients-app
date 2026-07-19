class DoctorSchedule < ApplicationRecord
  belongs_to :doctor

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :appointment_duration, numericality: { greater_than: 0 }
  validates :appointment_mode, inclusion: { in: %w[walk_in scheduled] }
  validate :end_time_after_start_time

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:day_of_week, :start_time) }

  DAY_NAMES = %w[Domingo Lunes Martes Miércoles Jueves Viernes Sábado].freeze

  def day_name
    DAY_NAMES[day_of_week] || day_of_week.to_s
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time
    if end_time <= start_time
      errors.add(:end_time, 'debe ser posterior a la hora de inicio')
    end
  end
end
