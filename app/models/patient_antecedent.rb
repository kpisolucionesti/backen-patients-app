class PatientAntecedent < ApplicationRecord
  belongs_to :patient

  validates :condition_type, presence: true
end
