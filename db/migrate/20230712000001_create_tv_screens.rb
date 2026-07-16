class CreateTvScreens < ActiveRecord::Migration[7.0]
  def change
    create_table :tv_screens do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :pin_digest, null: false
      t.string :public_id, null: false
      t.boolean :is_active, default: true
      t.timestamps
    end
    add_index :tv_screens, :public_id, unique: true
  end
end
