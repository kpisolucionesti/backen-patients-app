class TvScreenSession < ApplicationRecord
  belongs_to :tv_screen

  before_create :generate_auth_token

  scope :active, -> { where(revoked_at: nil) }

  def revoke!
    update!(revoked_at: Time.current)
  end

  def active?
    revoked_at.nil?
  end

  private

  def generate_auth_token
    self.auth_token = loop do
      token = SecureRandom.hex(32)
      break token unless self.class.exists?(auth_token: token)
    end
  end
end
