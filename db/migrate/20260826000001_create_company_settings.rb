class CreateCompanySettings < ActiveRecord::Migration[7.0]
  def change
    create_table :company_settings do |t|
      t.string :company_name, null: false, default: "Emerboard"
      t.string :rif
      t.string :address
      t.string :city
      t.string :state
      t.string :country, default: "VE"
      t.string :phone
      t.string :email
      t.string :website
      t.timestamps
    end
  end
end
