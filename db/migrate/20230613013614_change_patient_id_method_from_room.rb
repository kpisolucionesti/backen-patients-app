class ChangePatientIdMethodFromRoom < ActiveRecord::Migration[7.0]
  def change
    change_column :rooms, :patient_id, :integer
  end
end
