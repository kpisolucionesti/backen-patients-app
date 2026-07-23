class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.text :diagnostic_impression
      t.text :plan
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :evaluations, [:emergency_id, :doctor_id], unique: true
  end
end
