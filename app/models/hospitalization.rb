class Hospitalization < ApplicationRecord
  belongs_to :emergency
  belongs_to :room, optional: true
  belongs_to :admitting_doctor, class_name: 'Doctor', optional: true
  belongs_to :attending_doctor, class_name: 'Doctor', optional: true

  has_many :hospitalization_notes, dependent: :destroy
  has_many :fluid_balances, dependent: :destroy
  has_many :medication_administrations, dependent: :destroy
  has_many :surgeries, dependent: :destroy

  validates :emergency, presence: true
  validates :admission_date, presence: true
  validates :status, inclusion: { in: %w[active discharged] }
  validates :admission_diagnosis, length: { maximum: 2000 }, allow_blank: true
  validates :discharge_diagnosis, length: { maximum: 2000 }, allow_blank: true
  validates :discharge_summary, length: { maximum: 5000 }, allow_blank: true

  scope :active, -> { where(status: 'active') }

  def total_fluid_intake
    fluid_balances.where(balance_type: 'intake').sum(:amount)
  end

  def total_fluid_output
    fluid_balances.where(balance_type: 'output').sum(:amount)
  end

  def net_fluid_balance
    total_fluid_intake - total_fluid_output
  end

  def length_of_stay_days
    start_date = admission_date.to_date
    end_date = (discharge_date || Time.current).to_date
    (end_date - start_date).to_i
  end
end
