class AddDoctorIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :doctor, null: true, foreign_key: true
  end
end
