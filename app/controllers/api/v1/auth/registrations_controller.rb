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
          params.require(:user).permit(:email, :password, :password_confirmation, :name)
        end

        def user_response(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
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
