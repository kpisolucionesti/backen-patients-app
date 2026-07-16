namespace :patients do
  desc "Merge duplicate patients by normalized CI, consolidating emergencies/rooms/notes into the keeper"
  task merge_duplicates: :environment do
    ActiveRecord::Base.transaction do
      sql = <<~SQL
        SELECT regexp_replace(ci, '[^0-9]', '', 'g') AS clean_ci
        FROM patients
        WHERE ci IS NOT NULL AND ci != ''
        GROUP BY regexp_replace(ci, '[^0-9]', '', 'g')
        HAVING count(*) > 1 AND length(regexp_replace(ci, '[^0-9]', '', 'g')) > 0
      SQL

      clean_cis = ActiveRecord::Base.connection.execute(sql).map { |r| r['clean_ci'] }
      total_merged = 0

      clean_cis.each do |clean_ci|
        patients = Patient.where(
          "regexp_replace(ci, '[^0-9]', '', 'g') = ?", clean_ci
        ).to_a

        patients.sort_by! { |p| [-p.emergencies.count, p.id] }

        keep = patients.first
        to_merge = patients[1..]

        to_merge.each do |dup|
          print "  Merging patient #{dup.id} (ci='#{dup.ci}') into #{keep.id} (ci='#{keep.ci}')... "

          Emergency.where(patient_id: dup.id).update_all(patient_id: keep.id)
          Room.where(patient_id: dup.id).update_all(patient_id: keep.id)
          Note.where(patient_id: dup.id).update_all(patient_id: keep.id)

          dup.destroy!
          total_merged += 1
          puts "done"
        end
      end

      puts "\nMerge complete. #{total_merged} patients merged."
    end
  end
end
