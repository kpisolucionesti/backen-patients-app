class CreateMedicationPresentations < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_presentations do |t|
      t.string :name, null: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :medication_presentations, :name, unique: true
  end
end
