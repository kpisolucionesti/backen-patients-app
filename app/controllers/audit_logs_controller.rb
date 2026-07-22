class AuditLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize!('usuarios.view')

    logs = UserActivityLog.includes(:user)
                          .order(created_at: :desc)

    logs = logs.by_user(params[:user_id])
    logs = logs.by_action(params[:action_name])
    logs = logs.since(params[:from].present? ? Date.parse(params[:from]) : nil)
    logs = logs.until(params[:to].present? ? Date.parse(params[:to]) : nil)

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 100).to_i.clamp(1, 500)
    total = logs.count
    logs = logs.offset((page - 1) * per_page).limit(per_page)

    render json: {
      data: logs.map { |l|
        {
          id: l.id,
          user_id: l.user_id,
          user_name: l.user&.name,
          user_lastname: l.user&.lastname,
          action: l.action,
          description: l.description,
          ip_address: l.ip_address,
          user_agent: l.user_agent,
          metadata: l.metadata,
          created_at: l.created_at,
        }
      },
      total: total,
      page: page,
      per_page: per_page,
    }, status: :ok
  end
end
