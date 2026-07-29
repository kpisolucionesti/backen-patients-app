class MedicationRoute < ApplicationRecord
  has_many :medications, dependent: :restrict_with_error
  validates :name, presence: true, uniqueness: true
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:name) }
end
