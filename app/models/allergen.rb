class Allergen < ApplicationRecord
  validates :name, presence: true
end
