FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    password { "123456" }
    name { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    profile
    status { "active" }
    confirmed_at { Time.current }
  end
end
