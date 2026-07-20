class AddMedicalHistoryNumberToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :medical_history_number, :string
    Patient.where(medical_history_number: nil).find_each.with_index do |p, i|
      p.update_column(:medical_history_number, "MH-#{Time.current.year}-#{(i + 1).to_s.rjust(5, '0')}")
    end
    change_column_null :patients, :medical_history_number, false
    add_index :patients, :medical_history_number, unique: true
  end
end
