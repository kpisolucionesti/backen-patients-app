class PasswordPolicy < ApplicationRecord
  validates :min_length, numericality: { greater_than_or_equal_to: 6, less_than_or_equal_to: 64 }
  validates :expiry_days, numericality: { greater_than_or_equal_to: 0 }
  validates :max_failed_attempts, numericality: { greater_than: 0 }
  validates :lockout_duration_minutes, numericality: { greater_than: 0 }
end
