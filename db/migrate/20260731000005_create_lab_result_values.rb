class CreateLabResultValues < ActiveRecord::Migration[7.0]
  def change
    create_table :lab_result_values do |t|
      t.references :laboratory_result, null: false, foreign_key: true
      t.string :parameter_name
      t.string :value
      t.string :unit
      t.string :reference_range
      t.timestamps
    end
  end
end
