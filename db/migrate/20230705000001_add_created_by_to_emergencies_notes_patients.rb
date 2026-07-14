class AddCreatedByToEmergenciesNotesPatients < ActiveRecord::Migration[7.0]
  def change
    add_reference :emergencies, :created_by, foreign_key: { to_table: :users }, type: :bigint
    add_reference :notes, :created_by, foreign_key: { to_table: :users }, type: :bigint
    add_reference :patients, :created_by, foreign_key: { to_table: :users }, type: :bigint
  end
end
