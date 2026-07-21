class Emergency < ApplicationRecord
  STATUS_ESPERANDO = 0
  STATUS_ATENDIDO = 1
  STATUS_ALTA = 2
  STATUS_INGRESADO = 3
  STATUS_ANULADA = 4
  STATUS_FALLECIDO = 5

  VALID_STATUSES = (0..5).to_a.freeze

  CLASSIFICATIONS = %w[triage_iv triage_iii triage_ii triage_i consulta_externa].freeze

  belongs_to :patient
  belongs_to :created_by, class_name: 'User', optional: true
  has_many :emergency_doctors, dependent: :destroy
  has_many :doctors, through: :emergency_doctors
  has_many :medical_plans, dependent: :destroy
  has_many :interconsultations, dependent: :destroy
  has_many :notes, dependent: :nullify
  has_many :vital_signs, dependent: :destroy
  has_many :paraclinical_studies, dependent: :destroy
  has_one :physical_exam, dependent: :destroy
  has_many :laboratory_results, dependent: :destroy
  has_one :hospitalization, dependent: :destroy

  validates :patient, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }, allow_nil: true
  validates :classification, inclusion: { in: CLASSIFICATIONS }, allow_nil: true
  validates :diagnostic, length: { maximum: 2000 }, allow_blank: true
  validates :treatment, length: { maximum: 2000 }, allow_blank: true
  validates :observations, length: { maximum: 2000 }, allow_blank: true
  validates :reason_for_consultation, length: { maximum: 2000 }, allow_blank: true
  validates :current_illness, length: { maximum: 2000 }, allow_blank: true
  validates :discharge_note, length: { maximum: 5000 }, allow_blank: true
  validates :admission_note, length: { maximum: 5000 }, allow_blank: true
  validates :cause_of_death, length: { maximum: 2000 }, allow_blank: true

  def primary_doctor
    emergency_doctors.find_by(primary: true)&.doctor
  end

  def consulting_doctors
    emergency_doctors.where(primary: false).map(&:doctor)
  end
end
