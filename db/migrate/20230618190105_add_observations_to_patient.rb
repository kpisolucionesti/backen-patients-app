class AddObservationsToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :observations, :string
  end
end
