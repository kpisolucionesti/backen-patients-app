class CreateNewEmergencies < ActiveRecord::Migration[7.0]
  def change
    create_table :emergencies do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :ingress_date
      t.integer :status, default: 1
      t.string :medical_exit
      t.string :diagnostic
      t.string :treatment
      t.string :observations
      t.string :transfer
      t.timestamps
    end
  end
end
