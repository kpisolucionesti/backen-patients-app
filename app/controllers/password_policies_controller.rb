class PasswordPoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    policy = PasswordPolicy.first_or_initialize
    render json: policy
  end

  def update
    policy = PasswordPolicy.first_or_initialize
    if policy.update(password_policy_params)
      UserActivityLog.create!(user: @current_user, action: 'update_password_policy', description: "Actualizó políticas de contraseña")
      render json: policy, status: :ok
    else
      render json: { error: policy.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless @current_user&.admin?
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def password_policy_params
    params.permit(:min_length, :require_uppercase, :require_lowercase, :require_number, :require_special_char, :expiry_days, :max_failed_attempts, :lockout_duration_minutes)
  end
end
