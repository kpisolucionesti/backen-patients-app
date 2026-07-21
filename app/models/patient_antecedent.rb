class PatientAntecedent < ApplicationRecord
  belongs_to :patient

  validates :condition_type, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }, allow_blank: true
  validates :notes, length: { maximum: 2000 }, allow_blank: true
  validates :medication, length: { maximum: 2000 }, allow_blank: true
  validates :category, length: { maximum: 255 }, allow_blank: true
end
