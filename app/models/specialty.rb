class Specialty < ApplicationRecord
  has_many :doctors, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
end
