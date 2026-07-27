class AddEmergencyToMedicationAdministrations < ActiveRecord::Migration[7.0]
  def change
    change_column_null :medication_administrations, :hospitalization_id, true
    add_reference :medication_administrations, :emergency, foreign_key: true
  end
end
