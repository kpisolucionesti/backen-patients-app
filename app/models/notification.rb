class Notification < ApplicationRecord
  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(50) }
  scope :since, ->(timestamp) { where("created_at > ?", timestamp) if timestamp.present? }
end
