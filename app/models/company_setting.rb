class CompanySetting < ApplicationRecord
  has_one_attached :logo

  validates :company_name, presence: true
end
