class CreateSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :specialties do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :specialties, :name, unique: true
  end
end
