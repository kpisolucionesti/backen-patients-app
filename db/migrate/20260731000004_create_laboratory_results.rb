class CreateLaboratoryResults < ActiveRecord::Migration[7.0]
  def change
    create_table :laboratory_results do |t|
      t.references :emergency, null: false, foreign_key: true
      t.datetime :result_date
      t.text :notes
      t.timestamps
    end
  end
end
