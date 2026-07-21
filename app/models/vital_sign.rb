class VitalSign < ApplicationRecord
  belongs_to :emergency, touch: true
  belongs_to :recorded_by, class_name: 'User'

  validates :systolic_bp, numericality: { in: 50..300, allow_nil: true }
  validates :diastolic_bp, numericality: { in: 30..200, allow_nil: true }
  validates :heart_rate, numericality: { in: 20..300, allow_nil: true }
  validates :respiratory_rate, numericality: { in: 4..80, allow_nil: true }
  validates :temperature, numericality: { in: 30.0..45.0, allow_nil: true }
  validates :oxygen_saturation, numericality: { in: 0..100, allow_nil: true }
  validates :glucose, numericality: { in: 0..1000, allow_nil: true }
  validates :height, numericality: { in: 20.0..250.0, allow_nil: true }
  validates :weight, numericality: { in: 1.0..400.0, allow_nil: true }

  before_save :calculate_bmi

  private

  def calculate_bmi
    if height.present? && weight.present? && height > 0
      height_in_meters = height / 100.0
      self.bmi = (weight / (height_in_meters ** 2)).round(1)
    end
  end
end
