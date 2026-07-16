namespace :migrate do
  desc "Merge duplicate patients (CI with -2/-3 suffixes) into canonical records"
  task merge_duplicate_patients: :environment do
    duplicated = Patient.where("ci ~ '-[0-9]+$'")
    total = duplicated.count
    puts "Found #{total} duplicate patients"

    merged = 0
    errors = []

    duplicated.find_each do |dup|
      original_ci = dup.ci.sub(/-[0-9]+$/, '')
      canonical = Patient.find_by(ci: original_ci)

      unless canonical
        errors << "No canonical patient found for CI: #{dup.ci} (original: #{original_ci})"
        next
      end

      ActiveRecord::Base.transaction do
        Emergency.where(patient_id: dup.id).update_all(patient_id: canonical.id)
        Note.where(patient_id: dup.id).update_all(patient_id: canonical.id)
        Room.where(patient_id: dup.id).update_all(patient_id: canonical.id)
        dup.destroy!
      end

      merged += 1
      puts "  Merged patient ##{dup.id} (CI: #{dup.ci}) into ##{canonical.id} (CI: #{canonical.ci})"
    end

    puts "\nDone. Merged: #{merged}, Errors: #{errors.size}"
    errors.each { |e| puts "  ERROR: #{e}" } if errors.any?
  end
end
