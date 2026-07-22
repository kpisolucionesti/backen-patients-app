class CreateAccessPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :access_policies do |t|
      t.boolean :require_2fa, default: false
      t.boolean :ip_restriction_enabled, default: false
      t.text :allowed_ips
      t.text :blocked_ips
      t.timestamps
    end
  end
end
