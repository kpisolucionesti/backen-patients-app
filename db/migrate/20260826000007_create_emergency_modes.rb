class CreateEmergencyModes < ActiveRecord::Migration[7.0]
  def change
    create_table :emergency_modes do |t|
      t.boolean :system_blocked, default: false
      t.text :block_message, default: "Sistema en mantenimiento. Intente más tarde."
      t.datetime :blocked_at
      t.bigint :blocked_by_id
      t.datetime :scheduled_unblock_at
      t.timestamps
    end
  end
end
