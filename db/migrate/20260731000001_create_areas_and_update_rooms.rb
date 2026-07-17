class CreateAreasAndUpdateRooms < ActiveRecord::Migration[7.0]
  def up
    create_table :areas do |t|
      t.string :name, null: false
      t.string :room_type
      t.text :description
      t.timestamps
    end
    add_index :areas, :name, unique: true

    default_area = Area.create!(name: 'General', room_type: nil, description: 'Área sin clasificación específica')

    add_reference :rooms, :area, foreign_key: true
    Room.where(area_id: nil).update_all(area_id: default_area.id)

    change_column_null :rooms, :area_id, false
    remove_column :rooms, :room_type
    remove_column :rooms, :area
  end

  def down
    add_column :rooms, :area, :string
    add_column :rooms, :room_type, :string

    Room.all.each do |room|
      room_type = room.area&.room_type
      room.update_columns(room_type: room_type) if room_type
    end

    remove_reference :rooms, :area
    drop_table :areas
  end
end
