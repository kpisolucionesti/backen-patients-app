class CreateLabParameterGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :lab_parameter_groups do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
