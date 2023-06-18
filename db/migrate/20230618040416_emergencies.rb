class Emergencies < ActiveRecord::Migration[7.0]
  def change
    create_table :emergencies do |t|
      t.references :patient
      t.references :doctor
    end
  end
end
