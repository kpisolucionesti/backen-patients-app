class LabParameterGroup < ApplicationRecord
  has_many :lab_parameters, dependent: :destroy

  accepts_nested_attributes_for :lab_parameters, allow_destroy: true

  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end
