class AddSessionTrackingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_activity_at, :datetime
  end
end
