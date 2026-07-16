class AddPerformanceIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :emergencies, :ingress_date
    add_index :emergencies, :status
    add_index :emergencies, [:patient_id, :status]
    add_index :patients, :name
    add_index :patients, :lastname
  end
end
