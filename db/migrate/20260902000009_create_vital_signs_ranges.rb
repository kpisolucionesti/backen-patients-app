class CreateVitalSignsRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :vital_signs_ranges do |t|
      t.string :parameter, null: false
      t.decimal :age_min, precision: 5, scale: 1, default: 0
      t.decimal :age_max, precision: 5, scale: 1, default: 120
      t.string :sex, default: 'all'
      t.decimal :min_normal, precision: 8, scale: 2
      t.decimal :max_normal, precision: 8, scale: 2
      t.decimal :min_alert, precision: 8, scale: 2
      t.decimal :max_alert, precision: 8, scale: 2
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :vital_signs_ranges, [:parameter, :age_min, :age_max, :sex], name: 'idx_vsr_param_age_sex', unique: true
  end
end
