class Doctor < ApplicationRecord
    has_many :diagnostics
    has_many :emergency_doctors, dependent: :destroy
    has_many :emergencies, through: :emergency_doctors
end
