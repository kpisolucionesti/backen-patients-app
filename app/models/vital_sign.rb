class VitalSign < ApplicationRecord
  belongs_to :emergency, touch: true
  belongs_to :recorded_by, class_name: 'User'

  before_save :calculate_bmi

  private

  def calculate_bmi
    if height.present? && weight.present? && height > 0
      height_in_meters = height / 100.0
      self.bmi = (weight / (height_in_meters ** 2)).round(1)
    end
  end
end
