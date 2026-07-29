class BirthRecord < ApplicationRecord
  BIRTH_TYPES = %w[vaginal cesarea instrumentado].freeze

  belongs_to :mother_patient, class_name: 'Patient'
  belongs_to :baby_patient,   class_name: 'Patient'
  belongs_to :mother_emergency, class_name: 'Emergency'
  belongs_to :baby_emergency, class_name: 'Emergency'
  belongs_to :doctor, optional: true

  validates :birth_date, presence: true
  validates :birth_type, presence: true, inclusion: { in: BIRTH_TYPES }
  validates :birth_order, presence: true, numericality: { greater_than: 0 }

  def as_json(options = {})
    super(options).tap do |h|
      h['mother_patient'] = mother_patient.as_json(only: [:id, :name, :lastname, :ci]) if mother_patient
      h['baby_patient'] = baby_patient.as_json(only: [:id, :name, :lastname, :ci, :gender, :mother_id]) if baby_patient
    end
  end
end
