class AddDisabledToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :disabled, :boolean, default: false
  end
end
