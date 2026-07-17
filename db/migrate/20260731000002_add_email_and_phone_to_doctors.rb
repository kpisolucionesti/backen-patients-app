class AddEmailAndPhoneToDoctors < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :email, :string
    add_column :doctors, :phone, :string
  end
end
