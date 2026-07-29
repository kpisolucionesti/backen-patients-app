class AddMotherIdToPatients < ActiveRecord::Migration[7.0]
  def change
    add_reference :patients, :mother, foreign_key: { to_table: :patients }, index: true, null: true
  end
end
