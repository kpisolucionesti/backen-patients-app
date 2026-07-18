class CreateMedicationAdministrations < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_administrations do |t|
      t.references :hospitalization, null: false, foreign_key: true
      t.references :medical_plan, foreign_key: true
      t.references :administered_by, foreign_key: { to_table: :users }
      t.string :medication_name, null: false
      t.string :dosage
      t.string :route
      t.string :frequency
      t.datetime :scheduled_at
      t.datetime :administered_at
      t.string :status, default: 'scheduled'
      t.text :notes
      t.timestamps
    end
    add_index :medication_administrations, :status
    add_index :medication_administrations, :scheduled_at
  end
end
