class Allergen < ApplicationRecord
  CATEGORIES = %w[medicamento alimento ambiental latex otro].freeze
  validates :name, presence: true, uniqueness: true
  validates :category, inclusion: { in: CATEGORIES }
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:name) }
  scope :search, ->(q) { where('name ILIKE ?', "%#{q}%") if q.present? }
end
