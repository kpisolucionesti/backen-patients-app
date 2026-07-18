class HospitalizationNote < ApplicationRecord
  belongs_to :hospitalization
  belongs_to :created_by, class_name: 'User', optional: true

  validates :note_type, inclusion: { in: %w[progress nursing admission discharge] }
  validates :recorded_at, presence: true

  NOTE_TYPES = {
    progress: 'Evolución Médica',
    nursing: 'Nota de Enfermería',
    admission: 'Nota de Ingreso',
    discharge: 'Nota de Alta'
  }.freeze

  SHIFTS = {
    morning: 'Mañana',
    afternoon: 'Tarde',
    night: 'Noche'
  }.freeze

  def note_type_label
    NOTE_TYPES[note_type.to_sym] || note_type
  end

  def shift_label
    SHIFTS[shift.to_sym] || shift
  end
end
