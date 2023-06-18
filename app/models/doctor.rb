class Doctor < ApplicationRecord
    has_many :diagnostics
    has_many :patients
end
