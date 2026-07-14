module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        def create
          user = User.find_for_database_authentication(email: params[:email])

          if user && user.valid_password?(params[:password])
            if user.confirmed?
              if user.status == 'suspended'
                return render json: { status: "error", message: "Usuario suspendido" }, status: :unauthorized
              end
              user.ensure_authentication_token
              user.save!
              render json: {
                status: "success",
                message: "Signed in successfully",
                user: user_response(user),
                token: user.authentication_token
              }, status: :ok
            else
              render json: {
                status: "error",
                message: "You must confirm your email before signing in"
              }, status: :unauthorized
            end
          else
            render json: {
              status: "error",
              message: "Invalid email or password"
            }, status: :unauthorized
          end
        end

        def destroy
          user = authenticate_with_token
          if user
            user.invalidate_authentication_token
            render json: {
              status: "success",
              message: "Signed out successfully"
            }, status: :ok
          else
            render json: {
              status: "error",
              message: "Invalid token"
            }, status: :unauthorized
          end
        end

        private

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
