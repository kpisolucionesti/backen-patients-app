class CreateWebhookDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_deliveries do |t|
      t.references :webhook, null: false, foreign_key: true
      t.string :event, null: false
      t.jsonb :payload, default: {}
      t.integer :response_code
      t.text :response_body
      t.datetime :delivered_at
      t.timestamps
    end
    add_index :webhook_deliveries, [:webhook_id, :created_at]
  end
end
