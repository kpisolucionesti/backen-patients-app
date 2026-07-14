class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :permissions, default: []
      t.timestamps
    end
    add_index :profiles, :name, unique: true
  end
end
