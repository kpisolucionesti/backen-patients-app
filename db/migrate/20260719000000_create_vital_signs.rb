class CreateVitalSigns < ActiveRecord::Migration[7.0]
  def change
    create_table :vital_signs do |t|
      t.references :emergency, null: false, foreign_key: true
      t.integer :systolic_bp
      t.integer :diastolic_bp
      t.integer :heart_rate
      t.integer :respiratory_rate
      t.decimal :temperature, precision: 4, scale: 1
      t.integer :oxygen_saturation
      t.datetime :recorded_at, null: false
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
