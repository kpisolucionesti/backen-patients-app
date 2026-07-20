class SurgeryRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :hospitalization_id
  property :surgery_type
  property :description
  property :surgeon_name
  property :surgery_date
  property :status
  property :preanesthetic_evaluation
  property :area_id
  property :patient_id
  property :scheduled_start_time
  property :scheduled_end_time
  property :actual_start_time
  property :actual_end_time
  property :anesthesiologist
  property :anesthesia_type
  property :preop_notes
  property :postop_notes
  property :result
  property :ambulatory
  property :created_at
  property :updated_at

  collection_representer class: Surgery
end
