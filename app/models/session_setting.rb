class SessionSetting < ApplicationRecord
  validates :idle_timeout_minutes, numericality: { greater_than: 0, less_than_or_equal_to: 1440 }

  def self.idle_timeout
    first_or_create!.idle_timeout_minutes.minutes
  end
end
