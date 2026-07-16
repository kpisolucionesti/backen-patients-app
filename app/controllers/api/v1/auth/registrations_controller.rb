module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        def create
          user = User.new(sign_up_params)
          default_profile = Profile.find_by(name: 'User')
          user.profile = default_profile if default_profile
          user.skip_confirmation!

          if user.save
            begin
              raw_token = user.set_reset_password_token
              UserMailer.welcome_email(user, raw_token).deliver_now
            rescue => e
              Rails.logger.error("Error enviando correo de bienvenida: #{e.message}")
            end
            render json: {
              status: "success",
              message: "User created successfully",
              user: user_response(user),
              token: user.authentication_token
            }, status: :created
          else
            render json: {
              status: "error",
              message: "User could not be created",
              errors: user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:username, :name, :lastname, :email, :password, :password_confirmation, :profile_id)
        end

        def user_response(user)
          {
            id: user.id,
            username: user.username,
            email: user.email,
            name: user.name,
            lastname: user.lastname,
            profile_id: user.profile_id,
            permissions: user.effective_permissions,
            is_admin: user.admin?,
            confirmed: user.confirmed?
          }
        end
      end
    end
  end
end
