class CreateTreatments < ActiveRecord::Migration[7.0]
  def change
    create_table :treatments do |t|
      t.string :name
      t.references :diagnostic
      t.timestamps
    end
  end
end
