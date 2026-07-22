class CreateSessionSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :session_settings do |t|
      t.integer :idle_timeout_minutes, default: 15
      t.boolean :allow_concurrent_sessions, default: true
      t.timestamps
    end
  end
end
