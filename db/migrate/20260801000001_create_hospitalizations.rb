class CreateHospitalizations < ActiveRecord::Migration[7.0]
  def change
    create_table :hospitalizations do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :room, foreign_key: true
      t.references :admitting_doctor, foreign_key: { to_table: :doctors }
      t.references :attending_doctor, foreign_key: { to_table: :doctors }
      t.text :admission_diagnosis
      t.text :discharge_diagnosis
      t.text :discharge_summary
      t.datetime :admission_date, null: false
      t.datetime :discharge_date
      t.string :status, default: 'active'
      t.timestamps
    end
    add_index :hospitalizations, :status
    add_index :hospitalizations, [:emergency_id, :status], unique: true, where: "status = 'active'"
  end
end
