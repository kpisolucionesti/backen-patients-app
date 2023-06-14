class Diagnostic < ApplicationRecord
    belongs_to :doctor
    belongs_to :patient
    has_many :treatments
end
