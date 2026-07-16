class UserActivityLogsController < ApplicationController
    before_action :authenticate_user!

    def index
        authorize!('usuarios.view')
        logs = UserActivityLog.where(user_id: params[:user_id])
                               .order(created_at: :desc)
                               .limit(500)
        render json: logs.map { |l|
            {
                id: l.id,
                user_id: l.user_id,
                action: l.action,
                description: l.description,
                created_at: l.created_at
            }
        }, status: :ok
    end
end
