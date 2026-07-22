class PatientLifestyleHabit < ApplicationRecord
  belongs_to :patient

  validates :habito, presence: true, length: { maximum: 255 }
  validates :concurrencia, length: { maximum: 255 }, allow_blank: true
  validates :observaciones, length: { maximum: 5000 }, allow_blank: true
end
