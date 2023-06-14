class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :ci
      t.string :name
      t.integer :age
      t.string :gender
      t.timestamps
    end
  end
end
