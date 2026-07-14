class EmergencyDoctor < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor
end
