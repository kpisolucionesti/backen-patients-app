class CreateHospitalizationNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :hospitalization_notes do |t|
      t.references :hospitalization, null: false, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.string :note_type, null: false, default: 'progress'
      t.string :shift
      t.text :subjective
      t.text :objective
      t.text :assessment
      t.text :plan
      t.datetime :recorded_at, null: false
      t.timestamps
    end
    add_index :hospitalization_notes, :note_type
    add_index :hospitalization_notes, :recorded_at
  end
end
