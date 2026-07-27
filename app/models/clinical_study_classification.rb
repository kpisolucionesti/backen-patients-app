class ClinicalStudyClassification < ApplicationRecord
  has_many :lab_parameters, dependent: :nullify

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(sort_order: :asc, name: :asc) }
end
