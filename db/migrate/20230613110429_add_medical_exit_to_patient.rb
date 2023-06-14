class AddMedicalExitToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :medical_exit, :string
  end
end
