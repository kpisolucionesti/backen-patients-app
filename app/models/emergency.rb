class Emergency < ApplicationRecord
  belongs_to :patient
  has_many :emergency_doctors, dependent: :destroy
  has_many :doctors, through: :emergency_doctors


  def primary_doctor
    emergency_doctors.find_by(primary: true)&.doctor
  end

  def consulting_doctors
    emergency_doctors.where(primary: false).map(&:doctor)
  end
end
