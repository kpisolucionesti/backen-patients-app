class AddUsernameAndLastnameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :lastname, :string
    add_index :users, :username, unique: true

    reversible do |dir|
      dir.up do
        User.find_by(email: 'admin@emerboard.com')&.update!(username: 'admin')
        change_column_null :users, :username, false
      end
    end
  end
end
