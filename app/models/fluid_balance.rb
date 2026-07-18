class FluidBalance < ApplicationRecord
  belongs_to :hospitalization
  belongs_to :recorded_by, class_name: 'User', optional: true

  validates :balance_type, inclusion: { in: %w[intake output] }
  validates :fluid_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :recorded_at, presence: true

  INTAKE_TYPES = %w[oral intravenous enteral blood_transfusion].freeze
  OUTPUT_TYPES = %w[urine vomit diarrhea drainage bleeding].freeze

  BALANCE_TYPES = {
    intake: 'Ingreso',
    output: 'Egreso'
  }.freeze

  FLUID_TYPE_LABELS = {
    oral: 'Oral',
    intravenous: 'Intravenoso',
    enteral: 'Enteral',
    blood_transfusion: 'Transfusión',
    urine: 'Orina',
    vomit: 'Vómito',
    diarrhea: 'Diarrea',
    drainage: 'Drenaje',
    bleeding: 'Sangrado'
  }.freeze

  def balance_type_label
    BALANCE_TYPES[balance_type.to_sym] || balance_type
  end

  def fluid_type_label
    FLUID_TYPE_LABELS[fluid_type.to_sym] || fluid_type
  end
end
