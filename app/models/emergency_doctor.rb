class EmergencyDoctor < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor

  validates :emergency, presence: true
  validates :doctor, presence: true
end
