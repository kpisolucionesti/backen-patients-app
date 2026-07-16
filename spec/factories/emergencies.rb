FactoryBot.define do
  factory :emergency do
    patient
    ingress_date { Date.current }
    diagnostic { "DIAGNOSTICO DE PRUEBA" }
    treatment { "TRATAMIENTO DE PRUEBA" }
    status { Emergency::STATUS_ATENDIDO }

    after(:create) do |emergency, evaluator|
      create(:emergency_doctor, emergency: emergency, doctor: create(:doctor), primary: true)
    end
  end
end
