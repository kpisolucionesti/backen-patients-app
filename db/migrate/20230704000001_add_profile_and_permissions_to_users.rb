class AddProfileAndPermissionsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :profile, foreign_key: true
    add_column :users, :permissions, :jsonb, default: []
  end
end
