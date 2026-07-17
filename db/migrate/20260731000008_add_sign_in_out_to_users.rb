class AddSignInOutToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :last_sign_out_at, :datetime
  end
end
