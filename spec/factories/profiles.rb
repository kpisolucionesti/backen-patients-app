FactoryBot.define do
  factory :profile do
    sequence(:name) { |n| "User #{n}" }
    description { "Acceso basico" }
    permissions { ['emergencia.view', 'historial.view'] }

    trait :admin do
      name { "Administrador" }
      description { "Acceso completo" }
      permissions { User::ALL_PERMISSIONS }
    end
  end
end
