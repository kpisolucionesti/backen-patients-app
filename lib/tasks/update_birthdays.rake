namespace :update do
  desc "Actualiza birthdays desde CSV de Admisoft"
  task :birthdays => :environment do
    require 'csv'

    path = ENV['CSV_PATH'] || '/tmp/pacientes_admisoft.csv'
    stats = { updated: 0, not_found: 0, skipped: 0, errors: 0 }

    CSV.foreach(path, headers: true, col_sep: ';', encoding: 'UTF-8') do |row|
      cedula = row['Cedula Paciente'].to_s.strip
      birthday_str = row['F. Nacimiento'].to_s.strip

      if cedula.empty? || cedula == '0'
        stats[:skipped] += 1
        next
      end
      if birthday_str.empty?
        stats[:skipped] += 1
        next
      end

      birthday = Date.strptime(birthday_str, '%d/%m/%Y') rescue nil
      unless birthday
        stats[:errors] += 1
        next
      end

      clean_ci = cedula.gsub(/\D/, '')
      patient = Patient.find_by(ci: clean_ci)

      if patient
        patient.update_column(:birthday, birthday)
        stats[:updated] += 1
      else
        stats[:not_found] += 1
      end
    end

    puts "=== Resumen ==="
    puts "Actualizados: #{stats[:updated]}"
    puts "No encontrados (CI en CSV sin match en DB): #{stats[:not_found]}"
    puts "Omitidos (menores/sin fecha): #{stats[:skipped]}"
    puts "Errores de formato fecha: #{stats[:errors]}"
  end
end
