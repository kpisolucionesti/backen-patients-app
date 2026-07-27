class AddNoteTypeToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :note_type, :string, default: 'general'
    add_index :notes, :note_type
  end
end
