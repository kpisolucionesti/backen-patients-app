class Emergency < ApplicationRecord
  belongs_to :patient
  belongs_to :created_by, class_name: 'User', optional: true
  has_many :emergency_doctors, dependent: :destroy
  has_many :doctors, through: :emergency_doctors
  has_many :medical_plans, dependent: :destroy

  STATUS_ATENDIDO = 1
  STATUS_ALTA = 2
  STATUS_INGRESADO = 3

  def primary_doctor
    emergency_doctors.find_by(primary: true)&.doctor
  end

  def consulting_doctors
    emergency_doctors.where(primary: false).map(&:doctor)
  end
end
