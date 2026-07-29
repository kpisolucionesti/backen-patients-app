class MedicationPresentation < ApplicationRecord
  validates :name, presence: true
end
