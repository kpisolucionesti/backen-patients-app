class Patient < ApplicationRecord
  has_many :emergencies, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :allergies, class_name: 'PatientAllergy', dependent: :destroy
  has_many :antecedents, class_name: 'PatientAntecedent', dependent: :destroy

  scope :active, -> { where(disabled: [nil, false]) }

  def disabled?
    disabled == true
  end
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

  def last_visit_date
    emergencies.order(ingress_date: :desc).first&.ingress_date
  end

  def stats
    total_visits = emergencies.count
    last_visit = emergencies.order(ingress_date: :desc).first
    {
      total_visits: total_visits,
      last_visit_date: last_visit&.ingress_date,
      last_visit_status: last_visit&.status,
      age: age
    }
  end

  private

  def normalize_ci
    return unless ci_changed? || representante_ci_changed?
    self.ci = ci&.gsub(/\D/, '')
    self.representante_ci = representante_ci&.gsub(/\D/, '')
  end
end
