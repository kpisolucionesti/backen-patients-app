class AddBirthdayToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :birthday, :date
  end
end
