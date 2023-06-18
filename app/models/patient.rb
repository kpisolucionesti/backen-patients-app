class Patient < ApplicationRecord
  has_many :diagnostics
  has_many :doctors
end
