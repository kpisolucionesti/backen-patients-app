class Surgery < ApplicationRecord
  belongs_to :hospitalization

  validates :surgery_type, presence: true
  validates :status, inclusion: { in: %w[scheduled completed cancelled] }

  scope :scheduled, -> { where(status: 'scheduled') }
  scope :completed, -> { where(status: 'completed') }
end
