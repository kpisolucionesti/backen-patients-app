class CreateBirthRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :birth_records do |t|
      t.references :mother_patient, null: false, foreign_key: { to_table: :patients }
      t.references :baby_patient,   null: false, foreign_key: { to_table: :patients }
      t.references :mother_emergency, null: false, foreign_key: { to_table: :emergencies }
      t.references :baby_emergency, null: false, foreign_key: { to_table: :emergencies }
      t.datetime :birth_date, null: false
      t.string :birth_type, null: false
      t.integer :gestational_age_weeks
      t.decimal :birth_weight_grams, precision: 10, scale: 2
      t.integer :apgar_1min
      t.integer :apgar_5min
      t.integer :birth_order, default: 1
      t.text :complications
      t.text :observations
      t.timestamps
    end

    add_index :birth_records, :birth_order
  end
end
