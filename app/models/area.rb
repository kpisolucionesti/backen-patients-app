class Area < ApplicationRecord
  has_many :rooms, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :room_type, inclusion: { in: %w[adulto pediatria hospitalizacion quirofano uci], allow_nil: true }
end
