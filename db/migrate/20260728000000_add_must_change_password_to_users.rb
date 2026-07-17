class AddMustChangePasswordToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :must_change_password, :boolean, default: true
    User.update_all(must_change_password: false)
  end
end
