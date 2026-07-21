class UserActivityLog < ApplicationRecord
  belongs_to :user

  validates :action, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }, allow_blank: true
end
