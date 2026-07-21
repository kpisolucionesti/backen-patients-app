class AddCredentialsToDoctors < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :ci, :string
    add_column :doctors, :doctor_code, :string
    add_column :doctors, :sanidad_number, :string
  end
end
