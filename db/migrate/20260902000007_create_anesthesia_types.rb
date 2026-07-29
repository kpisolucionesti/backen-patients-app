class CreateAnesthesiaTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :anesthesia_types do |t|
      t.string :name, null: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :anesthesia_types, :name, unique: true
  end
end
