module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        before_action :authenticate_user!, only: [:keep_alive]

        def create
          user = User.find_for_database_authentication(username: params[:username])

          unless user && user.confirmed?
            return render json: { status: "error", message: "Usuario o contraseña inválidos" }, status: :unauthorized
          end

          if user.status == 'suspended'
            return render json: { status: "error", message: "Cuenta suspendida. Contacte al administrador." }, status: :unauthorized
          end

          if user.blocked?
            return render json: { status: "error", message: "Cuenta bloqueada por el administrador." }, status: :unauthorized
          end

          user.auto_unlock_if_expired!

          if user.locked?
            return render json: { status: "error", message: "Usuario o contraseña inválidos" }, status: :unauthorized
          end

          if user.valid_password?(params[:password])
            user.update!(failed_attempts: 0, locked_at: nil, lock_count: 0)
            user.ensure_authentication_token
            user.last_activity_at = Time.current
            user.last_sign_in_at = Time.current
            user.save!
            UserActivityLog.create!(
              user: user,
              action: 'sign_in',
              description: "Inició sesión"
            )
            render json: {
              status: "success",
              message: "Signed in successfully",
              user: user_response(user),
              token: user.authentication_token
            }, status: :ok
          else
            user.increment!(:failed_attempts)
            if user.failed_attempts >= User::MAX_FAILED_ATTEMPTS
              user.increment!(:lock_count)
              if user.lock_count >= User::MAX_LOCKS
                user.update!(status: 'suspended', locked_at: nil)
                UserActivityLog.create!(
                  user: user,
                  action: 'auto_suspend',
                  description: "Cuenta suspendida automáticamente por alcanzar #{User::MAX_LOCKS} bloqueos de seguridad"
                )
              else
                user.update!(locked_at: Time.current)
              end
            end
            render json: {
              status: "error",
              message: "Usuario o contraseña inválidos"
            }, status: :unauthorized
          end
        end

        def destroy
          user = authenticate_with_token
          if user
            user.invalidate_authentication_token
            user.last_sign_out_at = Time.current
            user.save!
            UserActivityLog.create!(
              user: user,
              action: 'sign_out',
              description: "Cerró sesión"
            )
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

        def keep_alive
          render json: { status: "success", message: "Session active" }, status: :ok
        end

        private

        def user_response(user)
          {
            id: user.id,
            username: user.username,
            email: user.email,
            name: user.name,
            lastname: user.lastname,
            profile_id: user.profile_id,
            doctor_id: user.doctor_id,
            permissions: user.effective_permissions,
            is_admin: user.admin?,
            must_change_password: user.must_change_password,
            confirmed: user.confirmed?
          }
        end
      end
    end
  end
end
