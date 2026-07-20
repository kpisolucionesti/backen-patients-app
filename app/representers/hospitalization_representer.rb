class HospitalizationRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :emergency_id
  property :room_id
  property :admitting_doctor_id
  property :attending_doctor_id
  property :admission_diagnosis
  property :discharge_diagnosis
  property :discharge_summary
  property :admission_date
  property :discharge_date
  property :status
  property :length_of_stay_days
  property :total_fluid_intake
  property :total_fluid_output
  property :net_fluid_balance
  property :created_at
  property :updated_at

  property :admitting_doctor do
    property :id
    property :name
    property :speciality
  end

  property :attending_doctor do
    property :id
    property :name
    property :speciality
  end

  property :room do
    property :id
    property :name
  end

  property :emergency do
    property :id
    property :status
    property :diagnostic
    property :classification
    property :transfer

    property :patient do
      property :id
      property :name
      property :lastname
      property :ci
      property :gender
      property :birthday
      property :age
    end
  end

  collection :surgeries, decorator: SurgeryRepresenter, class: Surgery
end
