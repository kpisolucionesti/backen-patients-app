Devise.setup do |config|
  config.mailer_sender = "noreply@emerboard.com"
  config.mailer = "CustomDeviseMailer"

  require "devise/orm/active_record"

  config.authentication_keys = [:username]
  config.case_insensitive_keys = [:email, :username]
  config.strip_whitespace_keys = [:email, :username]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
