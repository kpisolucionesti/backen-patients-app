class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.string :medication, null: false
      t.string :dosage
      t.string :frequency
      t.string :duration
      t.string :route
      t.text :indications

      t.timestamps
    end
  end
end
