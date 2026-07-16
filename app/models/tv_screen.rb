require 'bcrypt'

class TvScreen < ApplicationRecord
  has_many :sessions, class_name: 'TvScreenSession', dependent: :destroy
  has_many :events, class_name: 'TvScreenEvent', dependent: :destroy

  before_create :generate_public_id

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :route, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: 'solo minúsculas, números y guiones' }

  def authenticate_pin(pin)
    BCrypt::Password.new(pin_digest) == pin
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def active_sessions
    sessions.where(revoked_at: nil)
  end

  def connected?
    active_sessions.where('last_seen_at > ?', 2.minutes.ago).exists?
  end

  scope :active, -> { where(is_active: true) }

  def self.pin_digest(pin)
    BCrypt::Password.create(pin)
  end

  private

  def generate_public_id
    self.public_id = loop do
      token = SecureRandom.hex(16)
      break token unless self.class.exists?(public_id: token)
    end
  end
end
