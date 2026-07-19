class CreateAppointmentDisplays < ActiveRecord::Migration[7.0]
  def change
    create_table :appointment_displays do |t|
      t.string :name, null: false
      t.string :location
      t.references :specialty, foreign_key: true
      t.boolean :is_active, default: true, null: false
      t.string :public_id, null: false
      t.timestamps
    end
    add_index :appointment_displays, :public_id, unique: true
  end
end
