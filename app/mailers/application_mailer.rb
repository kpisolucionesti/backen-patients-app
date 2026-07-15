class ApplicationMailer < ActionMailer::Base
  layout "mailer"

  private

  def apply_email_settings
    settings = EmailSetting.first
    settings&.apply!
  end
end
