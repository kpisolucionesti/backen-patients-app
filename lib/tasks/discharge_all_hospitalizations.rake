namespace :hospitalizations do
  desc "Dar de alta todas las hospitalizaciones activas"
  task discharge_all: :environment do
    count = 0
    Hospitalization.where(status: 'active').find_each do |hosp|
      hosp.update!(
        status: 'discharged',
        discharge_date: Time.current,
        discharge_diagnosis: hosp.admission_diagnosis,
        room_id: nil
      )
      hosp.emergency&.update!(status: Emergency::STATUS_ALTA)
      count += 1
    end
    puts "#{count} hospitalizaciones dadas de alta correctamente."
  end
end
