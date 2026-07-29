class SurgeryProcedure < ApplicationRecord
  CATEGORIES = %w[general traumatologia neurocirugia cardiovascular toracica abdominal urologica ginecologica oftalmologica otorrino maxilofacial pediatrica otros].freeze
  validates :name, presence: true
  validates :code, uniqueness: true, allow_blank: true
  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:category, :name) }
  scope :search, ->(q) { where('name ILIKE ? OR code ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }
end
