class ParaclinicalStudy < ApplicationRecord
  belongs_to :emergency

  validates :study_type, presence: true
end
