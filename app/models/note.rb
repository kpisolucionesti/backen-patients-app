class Note < ApplicationRecord
    belongs_to :patient
    belongs_to :emergency, optional: true
    belongs_to :created_by, class_name: 'User', optional: true

    validates :note, presence: true, length: { maximum: 5000 }
end
