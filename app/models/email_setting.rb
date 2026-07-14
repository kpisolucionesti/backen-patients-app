class EmailSetting < ApplicationRecord
  validates :smtp_address, presence: true, if: -> { smtp_address.present? || smtp_username.present? }
  validates :smtp_port, presence: true, if: -> { smtp_address.present? }
  validates :smtp_username, presence: true, if: -> { smtp_address.present? }
  validates :sender_email, presence: true, if: -> { smtp_address.present? }

  def apply!
    ActionMailer::Base.smtp_settings = {
      address: smtp_address,
      port: smtp_port,
      user_name: smtp_username,
      password: smtp_password,
      authentication: authentication&.to_sym || :login,
      enable_starttls_auto: enable_starttls_auto,
    }
    ActionMailer::Base.default_options = { from: sender_email }
    ActionMailer::Base.default_url_options = { host: URI.parse(sender_email).host } if sender_email.present?
  end

  def test_connection
    return { success: false, error: "SMTP address not configured" } unless smtp_address.present?

    smtp = Net::SMTP.new(smtp_address, smtp_port)
    smtp.enable_starttls_auto if enable_starttls_auto
    smtp.start(smtp_address, smtp_username, smtp_password, authentication&.to_sym || :login)
    smtp.finish
    { success: true, message: "Conexion SMTP exitosa" }
  rescue => e
    { success: false, error: e.message }
  end
end
