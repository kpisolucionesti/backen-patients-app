class AddMissingPerformanceIndexes < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :notes, :patient_id, algorithm: :concurrently unless index_exists?(:notes, :patient_id)
    add_index :emergencies, :created_at, algorithm: :concurrently unless index_exists?(:emergencies, :created_at)
    add_index :emergencies, :egress_at, algorithm: :concurrently unless index_exists?(:emergencies, :egress_at)
  end
end
