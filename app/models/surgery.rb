class Surgery < ApplicationRecord
  belongs_to :hospitalization, optional: true
  belongs_to :area, optional: true
  belongs_to :patient, optional: true

  has_many :surgery_team_members, dependent: :destroy

  validates :surgery_type, presence: true
  validates :status, inclusion: { in: %w[scheduled in_progress completed cancelled] }
  validates :preanesthetic_evaluation, presence: true, if: -> { status == 'scheduled' || status == 'in_progress' || status == 'completed' }

  scope :scheduled, -> { where(status: 'scheduled') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :completed, -> { where(status: 'completed') }

  def ambulatory?
    hospitalization_id.nil? && patient_id.present?
  end
end
