class Note < ApplicationRecord
    belongs_to :patient
    belongs_to :created_by, class_name: 'User', optional: true
end
