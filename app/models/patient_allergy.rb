class PatientAllergy < ApplicationRecord
  belongs_to :patient

  validates :allergy, presence: true
  validates :severity, inclusion: { in: %w[leve moderado grave], allow_blank: true }
end
