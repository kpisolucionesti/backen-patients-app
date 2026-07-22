class CreatePatientLifestyleHabits < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_lifestyle_habits do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :habito, null: false
      t.string :concurrencia
      t.text :observaciones
      t.timestamps
    end
  end
end
