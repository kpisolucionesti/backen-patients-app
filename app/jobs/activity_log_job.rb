class ActivityLogJob < ApplicationJob
  queue_as :activity_logs

  def perform(user_id:, action:, description:)
    UserActivityLog.create!(
      user_id: user_id,
      action: action,
      description: description
    )
  end
end
