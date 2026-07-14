module Api
  module V1
    module Auth
      class PasswordsController < ApplicationController
        def create
          user = User.find_by(email: params[:email])
          if user
            user.send_reset_password_instructions
          end
          render json: { message: "Si el correo existe, recibira instrucciones para restablecer su contrasena" }, status: :ok
        end

        def update
          user = User.reset_password_by_token(reset_params)
          if user.errors.empty?
            user.ensure_authentication_token
            user.save!
            render json: {
              status: "success",
              message: "Contrasena restablecida exitosamente",
              token: user.authentication_token,
              user: {
                id: user.id,
                email: user.email,
                name: user.name,
                profile_id: user.profile_id,
                permissions: user.effective_permissions,
                is_admin: user.admin?,
                confirmed: user.confirmed?
              }
            }, status: :ok
          else
            render json: { status: "error", message: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
          end
        end

        private

        def reset_params
          params.permit(:reset_password_token, :password, :password_confirmation)
        end
      end
    end
  end
end
