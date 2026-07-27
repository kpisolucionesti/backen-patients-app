class LabParameter < ApplicationRecord
  belongs_to :lab_parameter_group, optional: true
  belongs_to :clinical_study_classification, optional: true

  validates :name, presence: true

  serialize :reference_ranges, coder: JSON

  scope :ordered, -> { order(sort_order: :asc, name: :asc) }
  scope :active, -> { where(is_active: true) }
  scope :by_classification, ->(id) { where(clinical_study_classification_id: id) }
end
