class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = Notification.unread.recent
    notifications = notifications.since(params[:since]) if params[:since].present?

    render json: notifications.map { |n|
      {
        id: n.id,
        notification_type: n.notification_type,
        title: n.title,
        message: n.message,
        link: n.link,
        emergency_id: n.emergency_id,
        read: n.read,
        created_at: n.created_at
      }
    }
  end

  def mark_read
    notification = Notification.find(params[:id])
    notification.update!(read: true)
    render json: { status: 'ok' }
  end

  def mark_all_read
    Notification.unread.update_all(read: true)
    render json: { status: 'ok' }
  end
end
