class WebhookDelivery < ApplicationRecord
  belongs_to :webhook

  scope :recent, -> { order(created_at: :desc).limit(50) }
  scope :successful, -> { where(response_code: 200..299) }
  scope :failed, -> { where.not(response_code: 200..299) }
end
