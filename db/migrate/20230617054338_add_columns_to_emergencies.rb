class AddColumnsToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :status, :integer
    add_column :emergencies, :ingress_date, :string
    add_column :emergencies, :medical_exit, :string
  end
end
