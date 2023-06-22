class AddColumnsToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :note, :string
    add_column :notes, :patient_id, :integer
  end
end
