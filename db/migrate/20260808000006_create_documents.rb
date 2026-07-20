class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :attachable_type, null: false
      t.bigint :attachable_id, null: false
      t.string :description
      t.string :file_type
      t.references :uploaded_by, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :documents, [:attachable_type, :attachable_id], name: 'idx_documents_on_attachable'
  end
end
