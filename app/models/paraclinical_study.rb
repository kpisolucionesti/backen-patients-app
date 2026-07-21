class ParaclinicalStudy < ApplicationRecord
  belongs_to :emergency

  validates :study_type, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }, allow_blank: true
end
