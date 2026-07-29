class AllergenCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:name) }
end
