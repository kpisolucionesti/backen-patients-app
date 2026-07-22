class AccessPoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    policy = AccessPolicy.first_or_initialize
    render json: policy
  end

  def update
    policy = AccessPolicy.first_or_initialize
    if policy.update(access_policy_params)
      UserActivityLog.create!(user: @current_user, action: 'update_access_policy', description: "Actualizó políticas de acceso")
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

  def access_policy_params
    params.permit(:require_2fa, :ip_restriction_enabled, :allowed_ips, :blocked_ips)
  end
end
