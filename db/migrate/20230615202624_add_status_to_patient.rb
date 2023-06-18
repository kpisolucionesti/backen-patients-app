class AddStatusToPatient < ActiveRecord::Migration[7.0]
  def change
	add_column :patients, :status, :integer
  end
end
