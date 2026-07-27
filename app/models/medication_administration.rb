class MedicationAdministration < ApplicationRecord
  belongs_to :hospitalization, optional: true
  belongs_to :emergency, optional: true
  belongs_to :medical_plan, optional: true
  belongs_to :administered_by, class_name: 'User', optional: true

  validates :medication_name, presence: true, length: { maximum: 255 }
  validates :status, inclusion: { in: %w[scheduled administered missed refused held] }
  validates :dosage, length: { maximum: 255 }, allow_blank: true
  validates :route, length: { maximum: 255 }, allow_blank: true
  validates :frequency, length: { maximum: 255 }, allow_blank: true
  validates :notes, length: { maximum: 2000 }, allow_blank: true
  validate :parent_presence

  STATUS_LABELS = {
    scheduled: 'Programado',
    administered: 'Administrado',
    missed: 'No Administrado',
    refused: 'Rechazado',
    held: 'Suspendido'
  }.freeze

  ROUTE_LABELS = {
    oral: 'Oral',
    intravenous: 'Intravenoso',
    intramuscular: 'Intramuscular',
    subcutaneous: 'Subcutáneo',
    topical: 'Tópico',
    inhalation: 'Inhalación',
    rectal: 'Rectal'
  }.freeze

  def status_label
    STATUS_LABELS[status.to_sym] || status
  end

  def route_label
    ROUTE_LABELS[route.to_sym] || route
  end

  private

  def parent_presence
    unless hospitalization_id.present? || emergency_id.present?
      errors.add(:base, 'Debe estar asociado a una hospitalización o emergencia')
    end
  end
end
