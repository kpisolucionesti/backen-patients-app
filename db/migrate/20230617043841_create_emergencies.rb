class CreateEmergencies < ActiveRecord::Migration[7.0]
  def change
    create_table :emergencies do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
