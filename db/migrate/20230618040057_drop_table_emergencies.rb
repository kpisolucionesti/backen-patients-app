class DropTableEmergencies < ActiveRecord::Migration[7.0]
  def change
    drop_table :emergencies
  end
end
