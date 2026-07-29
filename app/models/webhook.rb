class Webhook < ApplicationRecord
  EVENTS = %w[
    emergency.created emergency.discharged emergency.death
    hospitalization.admission hospitalization.discharge
    surgery.scheduled surgery.completed
    patient.created patient.updated
    appointment.created
  ].freeze

  has_many :deliveries, class_name: 'WebhookDelivery', dependent: :destroy

  validates :url, presence: true, format: URI.regexp(%w[http https])
  validates :event, presence: true, inclusion: { in: EVENTS }
  scope :active, -> { where(is_active: true) }
  scope :for_event, ->(event) { active.where(event: event) }

  def dispatch!(payload)
    delivery = deliveries.create!(event: event, payload: payload)
    WebhookDispatcher.perform_async(id, delivery.id)
    delivery
  end
end
