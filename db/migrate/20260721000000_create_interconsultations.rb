class CreateInterconsultations < ActiveRecord::Migration[7.0]
  def change
    create_table :interconsultations do |t|
      t.references :emergency, null: false, foreign_key: true
      t.references :doctor_requested, null: false, foreign_key: { to_table: :doctors }
      t.references :requested_by, foreign_key: { to_table: :users }
      t.text :reason
      t.text :observations
      t.string :status, default: 'pending'
      t.timestamps
    end

    add_index :interconsultations, :status
  end
end
