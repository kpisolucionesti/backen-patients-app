class VitalSignsRange < ApplicationRecord
  PARAMETERS = %w[systolic_bp diastolic_bp heart_rate respiratory_rate temperature oxygen_saturation glucose height weight bmi].freeze
  PARAMETER_LABELS = {
    systolic_bp: 'Presion Sistolica',
    diastolic_bp: 'Presion Diastolica',
    heart_rate: 'Frecuencia Cardiaca',
    respiratory_rate: 'Frecuencia Respiratoria',
    temperature: 'Temperatura',
    oxygen_saturation: 'Saturacion de Oxigeno',
    glucose: 'Glucosa',
    height: 'Talla',
    weight: 'Peso',
    bmi: 'IMC'
  }.freeze

  validates :parameter, presence: true, inclusion: { in: PARAMETERS }
  validates :sex, inclusion: { in: %w[M F all] }
  validates :age_min, :age_max, numericality: { greater_than_or_equal_to: 0 }
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:parameter, :age_min, :sex) }
end
