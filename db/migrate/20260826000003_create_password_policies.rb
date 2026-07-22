class CreatePasswordPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :password_policies do |t|
      t.integer :min_length, default: 8
      t.boolean :require_uppercase, default: true
      t.boolean :require_lowercase, default: true
      t.boolean :require_number, default: true
      t.boolean :require_special_char, default: true
      t.integer :expiry_days, default: 0
      t.integer :max_failed_attempts, default: 5
      t.integer :lockout_duration_minutes, default: 30
      t.timestamps
    end
  end
end
