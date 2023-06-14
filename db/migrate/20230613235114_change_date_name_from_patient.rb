class ChangeDateNameFromPatient < ActiveRecord::Migration[7.0]
  def change
    remove_column :patients, :current_date, :string
  end
end
