class VitalSignRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :systolic_bp
  property :diastolic_bp
  property :heart_rate
  property :respiratory_rate
  property :temperature
  property :oxygen_saturation
  property :glucose
  property :gcs_eye
  property :gcs_verbal
  property :gcs_motor
  property :pupil_left
  property :pupil_right
  property :pain_scale
  property :gcs_total
  property :recorded_at

  property :recorded_by do
    property :id
    property :name
    property :lastname
  end
end
