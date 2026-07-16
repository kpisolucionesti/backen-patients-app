FactoryBot.define do
  factory :medical_plan do
    emergency
    doctor
    description { Faker::Lorem.sentence }
    indication_type { MedicalPlan::INDICATION_TYPES.keys.sample.to_s }
    status { "active" }
    association :created_by, factory: :user
  end
end
