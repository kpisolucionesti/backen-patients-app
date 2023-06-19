class AddTransferToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :transfer, :string
  end
end
