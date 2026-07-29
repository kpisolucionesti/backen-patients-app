class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.jsonb :scopes, default: ['read']
      t.datetime :last_used_at
      t.datetime :expires_at
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :api_keys, :key, unique: true
  end
end
