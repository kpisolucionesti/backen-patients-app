class AddColumnToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :ingress_date, :string
    add_column :emergencies, :status, :integer
    add_column :emergencies, :medical_exit, :string
    add_column :emergencies, :diagnostic, :string
    add_column :emergencies, :treatment, :string
  end
end
