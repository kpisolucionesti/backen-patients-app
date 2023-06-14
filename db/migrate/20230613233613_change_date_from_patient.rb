class ChangeDateFromPatient < ActiveRecord::Migration[7.0]
  def change
    change_column :patients, :current_date, :string
  end
end
