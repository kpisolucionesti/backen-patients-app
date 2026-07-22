class PatientGynecologicalHistory < ApplicationRecord
  belongs_to :patient

  validates :evento, presence: true, length: { maximum: 255 }
  validates :observaciones, length: { maximum: 5000 }, allow_blank: true
end
