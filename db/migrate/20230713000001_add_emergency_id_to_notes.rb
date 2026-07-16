class AddEmergencyIdToNotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :notes, :emergency, foreign_key: true, null: true

    reversible do |dir|
      dir.up do
        Note.where(emergency_id: nil).find_each do |note|
          emergency = Emergency.where(patient_id: note.patient_id)
                               .where('created_at <= ?', note.created_at)
                               .order(created_at: :desc)
                               .first
          note.update_column(:emergency_id, emergency.id) if emergency
        end
      end
    end
  end
end
