class EmergencyMode < ApplicationRecord
  belongs_to :blocked_by, class_name: 'User', optional: true

  def self.blocked?
    mode = first
    mode&.system_blocked? && !mode_expired?(mode)
  end

  def self.mode_expired?(mode)
    mode.scheduled_unblock_at.present? && Time.current >= mode.scheduled_unblock_at
  end

  def self.block_system!(user:, message: nil, scheduled_unblock_at: nil)
    mode = first_or_initialize
    mode.update!(
      system_blocked: true,
      block_message: message || "Sistema en mantenimiento. Intente más tarde.",
      blocked_at: Time.current,
      blocked_by_id: user.id,
      scheduled_unblock_at: scheduled_unblock_at
    )
  end

  def self.unblock_system!
    mode = first_or_initialize
    mode.update!(
      system_blocked: false,
      blocked_at: nil,
      blocked_by_id: nil,
      scheduled_unblock_at: nil
    )
  end
end
