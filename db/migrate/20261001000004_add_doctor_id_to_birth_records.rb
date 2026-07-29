class AddDoctorIdToBirthRecords < ActiveRecord::Migration[7.0]
  def change
    add_reference :birth_records, :doctor, foreign_key: true, null: true
  end
end
