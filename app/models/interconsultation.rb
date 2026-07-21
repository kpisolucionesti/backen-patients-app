class Interconsultation < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor_requested, class_name: 'Doctor'
  belongs_to :requested_by, class_name: 'User', optional: true

  validates :status, inclusion: { in: %w[pending completed cancelled] }
  validates :reason, presence: true, length: { maximum: 5000 }
  validates :observations, length: { maximum: 5000 }, allow_blank: true
end
