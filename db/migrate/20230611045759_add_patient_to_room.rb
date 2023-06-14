class AddPatientToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :patient_id, :integer
  end
end
