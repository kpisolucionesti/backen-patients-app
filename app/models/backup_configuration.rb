class BackupConfiguration < ApplicationRecord
  validates :provider, presence: true
  validates :cron_schedule, presence: true
  validates :retention_days, numericality: { greater_than: 0 }

  PROVIDERS = %w[local aws gcp].freeze
end
