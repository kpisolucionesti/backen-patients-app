class RemoveUniqueIndexFromEvaluations < ActiveRecord::Migration[7.0]
  def change
    remove_index :evaluations, [:emergency_id, :doctor_id], unique: true
    add_index :evaluations, [:emergency_id, :doctor_id]
  end
end
