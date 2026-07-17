class EmailSettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def show
        settings = EmailSetting.first_or_initialize
        render json: {
            smtp_address: settings.smtp_address,
            smtp_port: settings.smtp_port,
            smtp_username: settings.smtp_username,
            smtp_password: settings.smtp_password.present?,
            sender_email: settings.sender_email,
            authentication: settings.authentication,
            enable_starttls_auto: settings.enable_starttls_auto,
        }
    end

    def update
        settings = EmailSetting.first_or_initialize
        if settings.update(email_settings_params)
            UserActivityLog.create!(user: @current_user, action: 'update_email_settings', description: "Actualizó configuración de correo")
            render json: { message: "Configuracion guardada exitosamente" }, status: :ok
        else
            render json: { error: settings.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def test
        settings = EmailSetting.new(test_params)
        result = settings.send_test_email
        if result[:success]
            UserActivityLog.create!(user: @current_user, action: 'test_email_settings', description: "Probó configuración de correo enviando a #{test_params[:sender_email]}")
            render json: { message: result[:message] }, status: :ok
        else
            render json: { error: result[:error] }, status: :unprocessable_entity
        end
    end

    private

    def require_admin!
        unless @current_user&.admin?
            render json: { error: "No autorizado" }, status: :forbidden
        end
    end

    def email_settings_params
        params.permit(:smtp_address, :smtp_port, :smtp_username, :smtp_password, :sender_email, :authentication, :enable_starttls_auto)
    end

    def test_params
        params.permit(:smtp_address, :smtp_port, :smtp_username, :smtp_password, :sender_email, :authentication, :enable_starttls_auto)
    end
end
