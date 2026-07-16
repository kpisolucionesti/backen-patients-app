class CreatePatientAntecedents < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_antecedents do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :condition_type, null: false
      t.text :description
      t.date :diagnosed_at
      t.text :notes
      t.timestamps
    end
  end
end
