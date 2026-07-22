class CreateGeneralSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :general_settings do |t|
      t.string :timezone, default: "America/Caracas"
      t.string :date_format, default: "dd/MM/yyyy"
      t.string :time_format, default: "HH:mm"
      t.string :locale, default: "es"
      t.boolean :notifications_enabled, default: true
      t.timestamps
    end
  end
end
