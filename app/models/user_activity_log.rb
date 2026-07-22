class UserActivityLog < ApplicationRecord
  belongs_to :user

  validates :action, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }, allow_blank: true

  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_action, ->(action) { where(action: action) if action.present? }
  scope :since, ->(date) { where('created_at >= ?', date) if date.present? }
  scope :until, ->(date) { where('created_at <= ?', date) if date.present? }
end
