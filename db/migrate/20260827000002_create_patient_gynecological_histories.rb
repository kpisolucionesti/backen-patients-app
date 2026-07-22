class CreatePatientGynecologicalHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_gynecological_histories do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :evento, null: false
      t.date :fecha_ultimo_evento
      t.text :observaciones
      t.timestamps
    end
  end
end
