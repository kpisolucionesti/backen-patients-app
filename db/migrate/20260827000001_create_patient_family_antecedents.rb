class CreatePatientFamilyAntecedents < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_family_antecedents do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :patologia, null: false
      t.string :parentesco
      t.string :valor
      t.timestamps
    end
  end
end
