class CreateEmergencyDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :emergency_doctors do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.boolean :primary, default: false
      t.timestamps
    end
  end
end
