class PatientAllergy < ApplicationRecord
  belongs_to :patient

  validates :allergy, presence: true, length: { maximum: 255 }
  validates :severity, inclusion: { in: %w[leve moderado grave], allow_blank: true }
  validates :notes, length: { maximum: 2000 }, allow_blank: true
end
