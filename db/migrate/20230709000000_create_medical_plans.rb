class CreateMedicalPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :medical_plans do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :doctor, foreign_key: true
      t.text :description, null: false
      t.string :indication_type, null: false
      t.string :status, default: "active"
      t.datetime :completed_at
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :medical_plans, :status
    add_index :medical_plans, :indication_type
  end
end
