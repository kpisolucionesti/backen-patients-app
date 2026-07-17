class Room < ApplicationRecord
  belongs_to :area
  delegate :room_type, to: :area, allow_nil: true

  validates :name, presence: true

  scope :available, -> { where(patient_id: nil) }
end
