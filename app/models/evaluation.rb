class Evaluation < ApplicationRecord
  belongs_to :emergency
  belongs_to :doctor
  belongs_to :created_by, class_name: 'User', optional: true

  validates :diagnostic_impression, length: { maximum: 5000 }, allow_blank: true
  validates :plan, length: { maximum: 5000 }, allow_blank: true
  validates :current_illness, length: { maximum: 5000 }, allow_blank: true
  validates :suggestions, length: { maximum: 5000 }, allow_blank: true
end
