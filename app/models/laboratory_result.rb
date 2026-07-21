class LaboratoryResult < ApplicationRecord
  belongs_to :emergency

  validates :emergency, presence: true
  validates :notes, length: { maximum: 5000 }, allow_blank: true

  has_many :lab_result_values, dependent: :destroy

  accepts_nested_attributes_for :lab_result_values, allow_destroy: true
end
