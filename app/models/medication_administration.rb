class MedicationAdministration < ApplicationRecord
  belongs_to :hospitalization
  belongs_to :medical_plan, optional: true
  belongs_to :administered_by, class_name: 'User', optional: true

  validates :medication_name, presence: true
  validates :status, inclusion: { in: %w[scheduled administered missed refused held] }

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
end
