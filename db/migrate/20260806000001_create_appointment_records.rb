class CreateAppointmentRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :appointment_records do |t|
      t.bigint :appointment_id, null: false
      t.text :reason_for_consultation
      t.text :current_illness
      t.text :diagnostic
      t.text :treatment
      t.text :observations
      t.jsonb :vital_signs
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :appointment_records, :appointment_id, unique: true
    add_foreign_key :appointment_records, :appointments
  end
end
