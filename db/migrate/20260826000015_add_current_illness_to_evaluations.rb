class AddCurrentIllnessToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :current_illness, :text unless column_exists?(:evaluations, :current_illness)
  end
end