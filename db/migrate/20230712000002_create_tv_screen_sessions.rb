class CreateTvScreenSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :tv_screen_sessions do |t|
      t.references :tv_screen, null: false, foreign_key: true
      t.string :auth_token, null: false
      t.string :ip_address
      t.datetime :last_seen_at
      t.datetime :revoked_at
      t.timestamps
    end
    add_index :tv_screen_sessions, :auth_token, unique: true
  end
end
