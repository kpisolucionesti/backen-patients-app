class PhysicalExam < ApplicationRecord
  belongs_to :emergency

  validates :emergency, presence: true
end
