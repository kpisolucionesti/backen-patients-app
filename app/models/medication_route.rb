class MedicationRoute < ApplicationRecord
  validates :name, presence: true
end
