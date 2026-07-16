class CreatePatientAllergies < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_allergies do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :allergy, null: false
      t.string :severity
      t.text :notes
      t.timestamps
    end
  end
end
