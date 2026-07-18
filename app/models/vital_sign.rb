class VitalSign < ApplicationRecord
  belongs_to :emergency
  belongs_to :recorded_by, class_name: 'User'

  def gcs_total
    [gcs_eye, gcs_verbal, gcs_motor].compact.sum
  end

  def gcs_total=(value)
  end
end
