class Area < ApplicationRecord
  has_many :rooms, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :room_type, inclusion: { in: %w[adulto pediatria hospitalizacion quirofano uci], allow_nil: true }
  validates :description, length: { maximum: 2000 }, allow_blank: true
end
