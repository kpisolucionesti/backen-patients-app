class CreateAllergens < ActiveRecord::Migration[7.0]
  def change
    create_table :allergens do |t|
      t.string :name, null: false
      t.string :category, default: 'otro'
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :allergens, :name, unique: true
    add_index :allergens, :category
  end
end
