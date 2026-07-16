class AddMedicationToPatientAntecedents < ActiveRecord::Migration[7.0]
  def change
    add_column :patient_antecedents, :medication, :text
  end
end
