class AddLoginAttemptsAndBlockToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :locked_at, :datetime
    add_column :users, :lock_count, :integer, default: 0, null: false
    add_column :users, :blocked_at, :datetime
  end
end
