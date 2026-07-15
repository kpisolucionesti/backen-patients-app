class Profile < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true

  RESERVED_NAMES = ['Administrador', 'User'].freeze

  def admin?
    name == 'Administrador'
  end

  def protected?
    name.in?(RESERVED_NAMES)
  end
end
