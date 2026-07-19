class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.references :specialty, null: false, foreign_key: true
      t.date :appointment_date, null: false
      t.time :start_time
      t.time :end_time
      t.string :status, null: false, default: 'scheduled'
      t.integer :turn_number
      t.text :notes
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :appointments, [:doctor_id, :appointment_date]
    add_index :appointments, [:appointment_date, :status]
  end
end
