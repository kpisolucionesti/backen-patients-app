class CreateMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :medications do |t|
      t.string :name, null: false
      t.string :generic_name
      t.string :presentation
      t.string :concentration
      t.references :medication_route, foreign_key: true, null: true
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :medications, :name
    add_index :medications, :generic_name
  end
end
