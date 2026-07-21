class MedicalPlan < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor, optional: true
  belongs_to :created_by, class_name: 'User', optional: true

  INDICATION_TYPES = {
    medication: 'Medicamento',
    procedure: 'Procedimiento',
    image: 'Imagen',
    lab: 'Laboratorio',
    general: 'General'
  }.freeze

  validates :emergency, presence: true
  validates :description, presence: true, length: { maximum: 5000 }
  validates :indication_type, inclusion: { in: INDICATION_TYPES.keys.map(&:to_s) }

  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
end
