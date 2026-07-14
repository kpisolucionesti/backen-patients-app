class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    private

    def authenticate_with_token
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      User.find_by(authentication_token: token)
    end

    def authenticate_user!
      @current_user = authenticate_with_token
      unless @current_user
        render json: { status: "error", message: "Authentication required" }, status: :unauthorized
      end
    end

    def authorize!(permission)
      return unless @current_user
      return if @current_user.admin?
      unless @current_user.effective_permissions.include?(permission)
        render json: { error: "No autorizado" }, status: :forbidden
      end
    end
end
