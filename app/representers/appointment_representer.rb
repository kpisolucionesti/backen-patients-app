class AppointmentRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :patient_id
  property :doctor_id
  property :specialty_id
  property :appointment_date
  property :start_time
  property :end_time
  property :status
  property :status_label
  property :turn_number
  property :notes
  property :created_at
  property :updated_at

  property :patient do
    property :id
    property :name
    property :lastname
    property :ci
  end

  property :doctor do
    property :id
    property :name
    property :specialty, decorator: SpecialtyRepresenter
  end

  property :specialty do
    property :id
    property :name
  end

  property :created_by do
    property :id
    property :name
  end
end
