class VitalSign < ApplicationRecord
  belongs_to :emergency
  belongs_to :recorded_by, class_name: 'User'
end
