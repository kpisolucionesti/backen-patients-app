class AddCauseOfDeathToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :cause_of_death, :text
  end
end
