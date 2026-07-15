class UserMailer < ApplicationMailer
  def welcome_email(user, raw_token)
    apply_email_settings
    @user = user
    @token = raw_token
    mail(to: user.email, subject: "Bienvenido a Emerboard")
  end

  def test_email(to_email)
    mail(to: to_email, subject: "Prueba de configuracion SMTP - Emerboard")
  end
end
