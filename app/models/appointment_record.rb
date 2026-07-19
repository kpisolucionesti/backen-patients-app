class AppointmentRecord < ApplicationRecord
  belongs_to :appointment
  belongs_to :created_by, class_name: 'User'

  validates :appointment, uniqueness: true
end
