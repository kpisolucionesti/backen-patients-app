class Diagnosis < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:code) }
  scope :search, ->(q) { where('code ILIKE :q OR description ILIKE :q', q: "%#{q}%") if q.present? }
end
