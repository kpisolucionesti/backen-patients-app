namespace :update do
  desc "Actualiza medical_history_number desde CSV de Admisoft"
  task :history_numbers => :environment do
    require 'csv'

    path = ENV['CSV_PATH'] || '/tmp/pacientes_admisoft.csv'
    stats = { updated: 0, unchanged: 0, not_found: 0 }

    by_ci = {}
    by_name = {}
    CSV.foreach(path, headers: true, col_sep: ';', encoding: 'UTF-8') do |row|
      cedula = row['Cedula Paciente'].to_s.strip
      next if cedula.empty? || cedula == '0'

      nro_historia = row['N. Historia'].to_s.strip
      next if nro_historia.empty?

      clean_ci = cedula.gsub(/\D/, '')
      by_ci[clean_ci] = row

      key = "#{row['Nombres Paciente'].to_s.strip.downcase}|#{row['Apellidos Paciente'].to_s.strip.downcase}"
      by_name[key] ||= row
    end

    patients = Patient.where.not(ci: nil).where.not(ci: '0')
    patients.find_each do |p|
      clean_ci = p.ci.to_s.gsub(/\D/, '')
      row = by_ci[clean_ci] || by_name["#{p.name.to_s.strip.downcase}|#{p.lastname.to_s.strip.downcase}"]

      if row
        nro = row['N. Historia'].to_s.strip
        next if p.medical_history_number == nro
        begin
          p.update_column(:medical_history_number, nro)
          stats[:updated] += 1
        rescue ActiveRecord::RecordNotUnique
          puts "  DUPLICADO: #{nro} para #{p.name} #{p.lastname} (CI: #{p.ci}) — ya existe en otro paciente, se omite"
          stats[:unchanged] += 1
        end
      else
        stats[:not_found] += 1
      end
    end

    puts "=== Resumen medical_history_number ==="
    puts "Actualizados: #{stats[:updated]}"
    puts "Sin cambios (ya igual): #{stats[:unchanged]}"
    puts "Sin match en CSV: #{stats[:not_found]}"
  end
end
