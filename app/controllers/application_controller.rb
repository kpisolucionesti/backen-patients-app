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
end
