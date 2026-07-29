class AddPatientCategoryToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :patient_category, :string, default: 'adulto', null: false
  end
end
