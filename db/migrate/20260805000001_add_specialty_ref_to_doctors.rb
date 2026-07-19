class AddSpecialtyRefToDoctors < ActiveRecord::Migration[7.0]
  def up
    add_reference :doctors, :specialty, foreign_key: true
    remove_column :doctors, :speciality
  end

  def down
    add_column :doctors, :speciality, :string
    remove_reference :doctors, :specialty
  end
end
