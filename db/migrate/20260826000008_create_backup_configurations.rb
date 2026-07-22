class CreateBackupConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :backup_configurations do |t|
      t.string :provider, default: "local"
      t.string :destination_path
      t.string :access_key_id
      t.string :secret_access_key
      t.string :region
      t.string :cron_schedule, default: "0 2 * * *"
      t.integer :retention_days, default: 30
      t.boolean :include_uploads, default: true
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
