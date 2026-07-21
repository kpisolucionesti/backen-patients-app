class Notification < ApplicationRecord
  belongs_to :emergency, optional: true

  validates :notification_type, presence: true, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }
  validates :message, length: { maximum: 5000 }, allow_blank: true
  validates :link, length: { maximum: 500 }, allow_blank: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(50) }
  scope :since, ->(timestamp) { where("created_at > ?", timestamp) if timestamp.present? }
end
