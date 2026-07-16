FactoryBot.define do
  factory :patient do
    ci { Faker::Number.unique.number(digits: 8).to_s }
    name { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    gender { %w[Masculino Femenino].sample }
    birthday { Faker::Date.birthday(min_age: 1, max_age: 90).to_s }
  end
end
