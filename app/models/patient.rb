class Patient < ApplicationRecord
  has_many :emergencies, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :ci, uniqueness: true

  def age
    return nil unless birthday
    now = Date.current
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end
end
