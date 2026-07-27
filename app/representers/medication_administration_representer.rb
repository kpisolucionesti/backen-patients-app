class MedicationAdministrationRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :hospitalization_id
  property :emergency_id
  property :medical_plan_id
  property :medication_name
  property :dosage
  property :route
  property :route_label
  property :frequency
  property :scheduled_at
  property :administered_at
  property :status
  property :status_label
  property :notes
  property :created_at
  property :updated_at

  property :administered_by do
    property :id
    property :name
    property :lastname
  end
end
