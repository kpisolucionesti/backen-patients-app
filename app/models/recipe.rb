class Recipe < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor

  validates :medication, presence: true
  validates :medication, length: { maximum: 255 }
  validates :dosage, length: { maximum: 255 }, allow_blank: true
  validates :frequency, length: { maximum: 255 }, allow_blank: true
  validates :duration, length: { maximum: 255 }, allow_blank: true
  validates :route, length: { maximum: 100 }, allow_blank: true
  validates :indications, length: { maximum: 2000 }, allow_blank: true
end
