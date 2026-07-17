class CreateLabParameters < ActiveRecord::Migration[7.0]
  def change
    create_table :lab_parameters do |t|
      t.references :lab_parameter_group, foreign_key: true, null: true
      t.string :name, null: false
      t.string :unit
      t.string :reference_range
      t.integer :sort_order, default: 0
      t.timestamps
    end
  end
end
