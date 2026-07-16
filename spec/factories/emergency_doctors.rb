FactoryBot.define do
  factory :emergency_doctor do
    emergency
    doctor
    primary { false }
  end
end
