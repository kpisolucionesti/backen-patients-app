class Medication < ApplicationRecord
  validates :name, presence: true

  def as_json(options = {})
    h = super(options)
    if h['medication_route'].present?
      h['medication_route'] = { 'name' => h['medication_route'] }
    end
    h
  end
end
