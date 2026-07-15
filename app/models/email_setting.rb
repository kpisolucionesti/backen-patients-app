class EmailSetting < ApplicationRecord
  validates :smtp_address, presence: true, if: -> { smtp_address.present? || smtp_username.present? }
  validates :smtp_port, presence: true, if: -> { smtp_address.present? }
  validates :smtp_username, presence: true, if: -> { smtp_address.present? }
  validates :sender_email, presence: true, if: -> { smtp_address.present? }

  TIMEOUT = 15

  def apply!
    ActionMailer::Base.smtp_settings = {
      address: smtp_address,
      port: smtp_port,
      user_name: smtp_username,
      password: smtp_password,
      authentication: authentication&.to_sym || :login,
      enable_starttls_auto: enable_starttls_auto,
      open_timeout: TIMEOUT,
      read_timeout: TIMEOUT,
    }
    UserMailer.default(from: sender_email) if sender_email.present?
    ActionMailer::Base.default_url_options = { host: URI.parse(sender_email).host } if sender_email.present?
  end

  def test_connection
    return { success: false, error: "SMTP address not configured" } unless smtp_address.present?

    smtp = Net::SMTP.new(smtp_address, smtp_port)
    smtp.open_timeout = TIMEOUT
    smtp.read_timeout = TIMEOUT
    smtp.enable_starttls_auto if enable_starttls_auto
    smtp.start(smtp_address, smtp_username, smtp_password, authentication&.to_sym || :login)
    smtp.finish
    { success: true, message: "Conexion SMTP exitosa" }
  rescue => e
    { success: false, error: e.message }
  end

  def send_test_email
    return { success: false, error: "SMTP address not configured" } unless smtp_address.present?
    return { success: false, error: "Sender email not configured" } unless sender_email.present?

    apply!
    UserMailer.test_email(sender_email).deliver_now
    { success: true, message: "Correo de prueba enviado a #{sender_email}" }
  rescue => e
    { success: false, error: e.message }
  end
end
