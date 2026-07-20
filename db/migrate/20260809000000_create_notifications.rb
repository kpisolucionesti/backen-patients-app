class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :notification_type, null: false
      t.string :title, null: false
      t.text :message
      t.string :link
      t.bigint :emergency_id
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    add_index :notifications, :read
    add_index :notifications, :created_at
  end
end
