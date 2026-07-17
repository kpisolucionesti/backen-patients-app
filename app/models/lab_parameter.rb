class LabParameter < ApplicationRecord
  belongs_to :lab_parameter_group, optional: true

  validates :name, presence: true

  serialize :reference_ranges, coder: JSON

  scope :ordered, -> { order(sort_order: :asc, name: :asc) }
end
