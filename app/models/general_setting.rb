class GeneralSetting < ApplicationRecord
  validates :timezone, presence: true
  validates :date_format, presence: true
  validates :locale, presence: true
end
