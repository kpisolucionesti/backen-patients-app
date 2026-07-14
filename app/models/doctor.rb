class Doctor < ApplicationRecord
    has_many :emergency_doctors, dependent: :destroy
    has_many :emergencies, through: :emergency_doctors

    scope :active, -> { where(status: 'active') }
    scope :suspended, -> { where(status: 'suspended') }
end
