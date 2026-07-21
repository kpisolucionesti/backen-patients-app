class LabResultValue < ApplicationRecord
  belongs_to :laboratory_result

  validates :parameter_name, length: { maximum: 255 }, allow_blank: true
  validates :value, length: { maximum: 255 }, allow_blank: true
  validates :unit, length: { maximum: 50 }, allow_blank: true
  validates :reference_range, length: { maximum: 255 }, allow_blank: true
end
