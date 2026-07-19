class Doctor < ApplicationRecord
    belongs_to :specialty, optional: true
    has_many :emergency_doctors, dependent: :destroy
    has_many :emergencies, through: :emergency_doctors
    has_many :schedules, class_name: 'DoctorSchedule', dependent: :destroy

    scope :active, -> { where(status: 'active') }
    scope :suspended, -> { where(status: 'suspended') }

    def speciality
      specialty&.name
    end
end
