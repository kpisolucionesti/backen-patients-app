namespace :ems do
  desc "Import production data from SQL dump to current schema"
  task :import, [:sql_path] => :environment do |_t, args|
    if Patient.count > 0 && ENV['FORCE'] != 'true'
      puts "Database already has #{Patient.count} patients. Aborting to prevent duplicates."
      puts "Run with FORCE=true to override: rails ems:import[...] FORCE=true"
      exit 1
    end

    sql_path = args[:sql_path]
    unless sql_path && File.exist?(sql_path)
      puts "Usage: rails ems:import[/path/to/dump.sql]"
      puts "       rails ems:import[/path/to/dump.sql] FORCE=true"
      exit 1
    end

    require Rails.root.join('lib/tasks/migrate_production_data.rake')
    Rake::Task['migrate:production_data'].invoke(sql_path)

    puts "\n=== Import complete ==="
    puts "Patients: #{Patient.count}"
    puts "Doctors: #{Doctor.count}"
    puts "Emergencies: #{Emergency.count}"
  end

  desc "Merge duplicate patients (CI with -2/-3 suffixes)"
  task merge: :environment do
    require Rails.root.join('lib/tasks/merge_duplicate_patients.rake')
    Rake::Task['migrate:merge_duplicate_patients'].invoke
  end

  desc "Full setup: migrate DB + import data + merge duplicates"
  task setup: :environment do
    Rake::Task['db:migrate'].invoke
    Rake::Task['ems:import'].invoke if ENV['SQL_PATH'].present?
    Rake::Task['ems:merge'].invoke
  end
end
