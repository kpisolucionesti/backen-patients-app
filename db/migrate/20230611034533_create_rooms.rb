class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_type
      t.string :name
      t.timestamps
    end
  end
end
