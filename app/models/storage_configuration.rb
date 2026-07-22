class StorageConfiguration < ApplicationRecord
  validates :provider, presence: true
  validates :local_path, presence: true, if: -> { provider == 'local' }
  validates :endpoint, presence: true, if: -> { provider != 'local' }
  validates :bucket, presence: true, if: -> { provider != 'local' }

  PROVIDERS = %w[local aws gcp digitalocean azure].freeze
end
