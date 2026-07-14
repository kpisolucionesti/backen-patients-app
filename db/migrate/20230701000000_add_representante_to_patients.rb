class AddRepresentanteToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :representante, :string
    add_column :patients, :representante_ci, :string
  end
end
