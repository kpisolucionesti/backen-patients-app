class CreateDiagnoses < ActiveRecord::Migration[7.0]
  def change
    create_table :diagnoses do |t|
      t.string :code, null: false
      t.text :description, null: false
      t.string :category
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :diagnoses, :code, unique: true
    add_index :diagnoses, :category
  end
end
