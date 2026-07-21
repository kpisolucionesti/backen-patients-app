class AppointmentRecord < ApplicationRecord
  belongs_to :appointment
  belongs_to :created_by, class_name: 'User'

  validates :appointment, uniqueness: true
  validates :reason_for_consultation, length: { maximum: 5000 }, allow_blank: true
  validates :current_illness, length: { maximum: 5000 }, allow_blank: true
  validates :diagnostic, length: { maximum: 5000 }, allow_blank: true
  validates :treatment, length: { maximum: 5000 }, allow_blank: true
  validates :observations, length: { maximum: 5000 }, allow_blank: true
end
