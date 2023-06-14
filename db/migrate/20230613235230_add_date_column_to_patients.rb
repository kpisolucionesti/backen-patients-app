class AddDateColumnToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :ingress_date, :string
  end
end
