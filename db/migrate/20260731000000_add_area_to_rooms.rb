class AddAreaToRooms < ActiveRecord::Migration[7.0]
  def up
    add_column :rooms, :area, :string
    change_column_null :rooms, :room_type, true
  end

  def down
    remove_column :rooms, :area
    change_column_null :rooms, :room_type, false
    Room.where(room_type: nil).update_all(room_type: 'adulto')
  end
end
