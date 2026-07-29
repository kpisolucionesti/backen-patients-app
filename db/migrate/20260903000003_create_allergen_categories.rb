class CreateAllergenCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :allergen_categories do |t|
      t.string :name, null: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :allergen_categories, :name, unique: true
  end
end
