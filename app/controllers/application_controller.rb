class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    class NotAuthorized < StandardError; end

    rescue_from NotAuthorized do |_exception|
      render json: { error: "No autorizado" }, status: :forbidden
    end

    private

    def authenticate_with_token
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      User.find_by(authentication_token: token)
    end

    def authenticate_with_tv_token
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      TvScreenSession.active.where('last_seen_at > ?', 2.minutes.ago).find_by(auth_token: token)
    end

    def authenticate_user!
      @current_user = authenticate_with_token
      unless @current_user
        render json: { status: "error", message: "Authentication required" }, status: :unauthorized
      end
    end

    def authenticate_tv_or_user!
      @current_user = authenticate_with_token
      return if @current_user

      tv_session = authenticate_with_tv_token
      if tv_session
        tv_session.update!(last_seen_at: Time.current)
        @is_tv = true
      else
        render json: { status: "error", message: "Authentication required" }, status: :unauthorized
      end
    end

    def authorize!(permission)
      if @is_tv
        unless %w[emergencia.view rooms.view].include?(permission)
          raise NotAuthorized
        end
        return
      end
      return unless @current_user
      return if @current_user.admin?

      unless @current_user.effective_permissions.include?(permission)
        raise NotAuthorized
      end
    end
end
