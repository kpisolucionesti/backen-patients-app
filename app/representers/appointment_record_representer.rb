class AppointmentRecordRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :appointment_id
  property :reason_for_consultation
  property :current_illness
  property :diagnostic
  property :treatment
  property :observations
  property :vital_signs
  property :created_at
  property :updated_at

  property :created_by do
    property :id
    property :name
  end
end
