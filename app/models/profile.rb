class Profile < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true

  def admin?
    name == 'Administrador'
  end
end
