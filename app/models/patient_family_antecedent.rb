class PatientFamilyAntecedent < ApplicationRecord
  belongs_to :patient

  validates :patologia, presence: true, length: { maximum: 255 }
  validates :parentesco, length: { maximum: 255 }, allow_blank: true
  validates :valor, length: { maximum: 255 }, allow_blank: true
end
