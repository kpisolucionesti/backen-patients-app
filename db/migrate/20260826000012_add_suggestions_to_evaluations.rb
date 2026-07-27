class AddSuggestionsToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :suggestions, :text
  end
end
