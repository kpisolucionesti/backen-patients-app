class AddDiagnosisFieldsToHospitalizations < ActiveRecord::Migration[7.0]
  def change
    add_column :hospitalizations, :current_diagnosis, :text
    add_column :hospitalizations, :final_diagnosis, :text
  end
end
