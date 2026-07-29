class CreateSurgeryProcedures < ActiveRecord::Migration[7.0]
  def change
    create_table :surgery_procedures do |t|
      t.string :code
      t.string :name, null: false
      t.string :category
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :surgery_procedures, :code, unique: true
    add_index :surgery_procedures, :category
  end
end
