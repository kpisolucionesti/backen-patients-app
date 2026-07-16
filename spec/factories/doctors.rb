FactoryBot.define do
  factory :doctor do
    name { Faker::Name.unique.name }
    speciality { "MEDICINA INTERNA" }
  end
end
