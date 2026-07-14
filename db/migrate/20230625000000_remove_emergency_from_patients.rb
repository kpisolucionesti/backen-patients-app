class RemoveEmergencyFromPatients < ActiveRecord::Migration[7.0]
  def change
    remove_column :patients, :age, :integer
    remove_column :patients, :medical_exit, :string
    remove_column :patients, :ingress_date, :string
    remove_column :patients, :status, :integer
    remove_column :patients, :current_diagnostic, :string
    remove_column :patients, :treatment, :string
    remove_column :patients, :current_doctor, :string
    remove_column :patients, :observations, :string
    remove_column :patients, :transfer, :string
  end
end
