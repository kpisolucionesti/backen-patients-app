class LaboratoryResult < ApplicationRecord
  belongs_to :emergency
  has_many :lab_result_values, dependent: :destroy

  accepts_nested_attributes_for :lab_result_values, allow_destroy: true
end
