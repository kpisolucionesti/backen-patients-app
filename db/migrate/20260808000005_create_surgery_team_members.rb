class CreateSurgeryTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :surgery_team_members do |t|
      t.references :surgery, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.string :role, null: false
      t.timestamps
    end

    add_index :surgery_team_members, [:surgery_id, :doctor_id, :role], unique: true, name: 'idx_surgery_team_members_unique'
  end
end
