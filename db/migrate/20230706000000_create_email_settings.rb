class CreateEmailSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :email_settings do |t|
      t.string :smtp_address
      t.integer :smtp_port, default: 587
      t.string :smtp_username
      t.string :smtp_password
      t.string :sender_email
      t.string :authentication, default: 'login'
      t.boolean :enable_starttls_auto, default: true
      t.timestamps
    end
  end
end
