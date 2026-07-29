class ApiKey < ApplicationRecord
  before_create :generate_key

  validates :name, presence: true
  scope :active, -> { where(is_active: true).where('expires_at IS NULL OR expires_at > ?', Time.current) }

  def regenerate!
    self.key = SecureRandom.hex(32)
    save!
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def touch_usage!
    update_column(:last_used_at, Time.current)
  end

  private

  def generate_key
    self.key = SecureRandom.hex(32)
  end
end
