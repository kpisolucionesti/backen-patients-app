class CreateWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.string :url, null: false
      t.string :event, null: false
      t.string :secret
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :webhooks, [:event, :is_active]
  end
end
