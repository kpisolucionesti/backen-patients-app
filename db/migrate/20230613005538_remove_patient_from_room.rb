class RemovePatientFromRoom < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :patient, :integer
  end
end
