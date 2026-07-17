class AddEvolutiveNotesToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :discharge_note, :text
    add_column :emergencies, :admission_note, :text
  end
end
