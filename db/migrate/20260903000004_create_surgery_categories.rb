class CreateSurgeryCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :surgery_categories do |t|
      t.string :name, null: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :surgery_categories, :name, unique: true
  end
end
