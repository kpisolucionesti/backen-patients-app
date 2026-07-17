class AddCategoryToPatientAntecedents < ActiveRecord::Migration[7.0]
  def change
    add_column :patient_antecedents, :category, :string
  end
end
