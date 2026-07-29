class Diagnosis < ApplicationRecord
  validates :code, presence: true
  validates :description, presence: true
end
