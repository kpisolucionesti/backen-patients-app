class EnrichUserActivityLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :user_activity_logs, :ip_address, :string
    add_column :user_activity_logs, :user_agent, :string
    add_column :user_activity_logs, :metadata, :jsonb, default: {}
    add_index :user_activity_logs, :created_at
  end
end
