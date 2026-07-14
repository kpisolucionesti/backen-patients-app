class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def regenerate_authentication_token
    update!(authentication_token: generate_authentication_token)
  end

  def invalidate_authentication_token
    update!(authentication_token: nil)
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.hex(32)
      break token unless User.exists?(authentication_token: token)
    end
  end
end
