class AddIsActiveToLabParameters < ActiveRecord::Migration[7.0]
  def change
    add_column :lab_parameters, :is_active, :boolean, default: true, null: false
    add_column :lab_parameter_groups, :is_active, :boolean, default: true, null: false
  end
end
