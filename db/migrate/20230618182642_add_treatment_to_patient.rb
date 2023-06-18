class AddTreatmentToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :treatment, :string
  end
end
