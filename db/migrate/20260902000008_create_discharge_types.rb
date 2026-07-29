class CreateDischargeTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :discharge_types do |t|
      t.string :name, null: false
      t.boolean :requires_cause_of_death, default: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :discharge_types, :name, unique: true
  end
end
