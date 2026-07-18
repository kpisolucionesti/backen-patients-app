class CreateSurgeries < ActiveRecord::Migration[7.0]
  def change
    create_table :surgeries do |t|
      t.references :hospitalization, null: false, foreign_key: true
      t.string :surgery_type
      t.text :description
      t.string :surgeon_name
      t.datetime :surgery_date
      t.string :status, default: 'scheduled'
      t.text :preop_notes
      t.text :postop_notes
      t.text :result
      t.timestamps
    end
  end
end
