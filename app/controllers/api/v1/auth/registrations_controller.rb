module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        def create
          user = User.new(sign_up_params)

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
            confirmed: user.confirmed?
          }
        end
      end
    end
  end
end
