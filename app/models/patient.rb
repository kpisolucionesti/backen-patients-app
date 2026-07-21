class Patient < ApplicationRecord
  GENDERS = %w[M F].freeze

  has_many :emergencies, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :allergies, class_name: 'PatientAllergy', dependent: :destroy
  has_many :antecedents, class_name: 'PatientAntecedent', dependent: :destroy
  has_many :appointments, dependent: :destroy

  scope :active, -> { where(disabled: [nil, false]) }

  def disabled?
    disabled == true
  end
  has_many :surgeries, dependent: :destroy
  belongs_to :created_by, class_name: 'User', optional: true

  validates :ci, uniqueness: true, allow_nil: true
  validates :name, presence: true
  validates :lastname, presence: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :birthday, presence: true
  validates :medical_history_number, presence: true, uniqueness: true
  validates :representante_ci, length: { maximum: 20 }, allow_blank: true
  validates :representante, length: { maximum: 255 }, allow_blank: true

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
    hospitalized_surgeries_count = Hospitalization.joins(:emergency)
                                                   .where(emergencies: { patient_id: id })
                                                   .joins(:surgeries)
                                                   .count
    ambulatory_surgeries_count = surgeries.where(hospitalization_id: nil).count
    surgeries_count = hospitalized_surgeries_count + ambulatory_surgeries_count
    hospitalizations_count = Hospitalization.joins(:emergency)
                                            .where(emergencies: { patient_id: id })
                                            .count
    {
      total_visits: total_visits,
      last_visit_date: last_visit&.ingress_date,
      last_visit_status: last_visit&.status,
      age: age,
      surgeries: surgeries_count,
      hospitalizations: hospitalizations_count,
      appointments: appointments.count
    }
  end

  private

  def normalize_ci
    return unless ci_changed? || representante_ci_changed?
    self.ci = ci&.gsub(/\D/, '')
    self.representante_ci = representante_ci&.gsub(/\D/, '')
  end
end
