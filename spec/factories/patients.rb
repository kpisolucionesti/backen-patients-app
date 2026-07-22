FactoryBot.define do
  factory :patient do
    ci { Faker::Number.unique.number(digits: 8).to_s }
    name { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    gender { %w[M F].sample }
    birthday { Faker::Date.birthday(min_age: 1, max_age: 90).to_s }

    factory :patient_with_family_antecedents do
      transient do
        family_antecedents_count { 3 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patient_family_antecedent, evaluator.family_antecedents_count, patient: patient)
      end
    end

    factory :patient_with_gynecological_histories do
      transient do
        gynecological_histories_count { 2 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patient_gynecological_history, evaluator.gynecological_histories_count, patient: patient)
      end
    end

    factory :patient_with_lifestyle_habits do
      transient do
        lifestyle_habits_count { 3 }
      end

      after(:create) do |patient, evaluator|
        create_list(:patient_lifestyle_habit, evaluator.lifestyle_habits_count, patient: patient)
      end
    end
  end

  factory :patient_family_antecedent do
    patient
    patologia { %w[Diabetes Hipertensión Cáncer Cardiopatía Asma].sample }
    parentesco { %w[Padre Madre Hermano Abuelo Tío].sample }
    valor { %w[Si No].sample }
  end

  factory :patient_gynecological_history do
    patient
    evento { %w[Menarquia FUM Citología Eco_Mamaria Menopausia].sample }
    fecha_ultimo_evento { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    observaciones { Faker::Lorem.sentence }
  end

  factory :patient_lifestyle_habit do
    patient
    habito { %w[Tabaquismo Alcohol Drogas Ejercicio Sedentarismo].sample }
    concurrencia { %w[Ocasional Frecuente Diario Nunca].sample }
    observaciones { Faker::Lorem.sentence }
  end
end
