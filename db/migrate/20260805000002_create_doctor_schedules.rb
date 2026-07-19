class CreateDoctorSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :doctor_schedules do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :appointment_duration, null: false, default: 30
      t.string :appointment_mode, null: false, default: 'scheduled'
      t.integer :max_patients, default: 0
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :doctor_schedules, [:doctor_id, :day_of_week], name: 'idx_doctor_schedules_on_doctor_and_day'
  end
end
