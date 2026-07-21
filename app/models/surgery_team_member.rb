class SurgeryTeamMember < ApplicationRecord
  belongs_to :surgery
  belongs_to :doctor

  validates :role, presence: true, inclusion: { in: %w[surgeon assistant anesthesiologist nurse perfusionist] }
  validates :doctor, presence: true
end
