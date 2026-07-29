class Medication < ApplicationRecord
  belongs_to :medication_route, optional: true
  validates :name, presence: true
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:name) }
  scope :search, ->(q) { where('name ILIKE ? OR generic_name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }
end
