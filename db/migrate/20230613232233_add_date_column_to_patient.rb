class AddDateColumnToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :current_date, :datetime
  end
end
