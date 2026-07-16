class Patient < ApplicationRecord
  has_many :emergencies, dependent: :destroy
  has_many :notes, dependent: :destroy
  belongs_to :created_by, class_name: 'User', optional: true

  validates :ci, uniqueness: true

  before_save :normalize_ci

  def age
    return nil unless birthday
    now = Date.current
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def minor?
    age && age < 18
  end

  private

  def normalize_ci
    return unless ci_changed? || representante_ci_changed?
    self.ci = ci&.gsub(/\D/, '')
    self.representante_ci = representante_ci&.gsub(/\D/, '')
  end
end
