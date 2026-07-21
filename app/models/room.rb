class Room < ApplicationRecord
  belongs_to :area
  delegate :room_type, to: :area, allow_nil: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :area, presence: true

  scope :available, -> { where(patient_id: nil) }
end
