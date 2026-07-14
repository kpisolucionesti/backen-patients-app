class CustomDeviseMailer < Devise::Mailer
  before_action :apply_email_settings

  private

  def apply_email_settings
    settings = EmailSetting.first
    settings&.apply!
  end
end
