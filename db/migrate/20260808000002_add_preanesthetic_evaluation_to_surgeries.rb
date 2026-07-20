class AddPreanestheticEvaluationToSurgeries < ActiveRecord::Migration[7.0]
  def change
    add_column :surgeries, :preanesthetic_evaluation, :text
  end
end
