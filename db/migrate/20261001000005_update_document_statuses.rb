class UpdateDocumentStatuses < ActiveRecord::Migration[7.0]
  def up
    Document.where(status: 'requested').update_all(status: 'pending')
  end

  def down
    Document.where(status: 'pending').update_all(status: 'requested')
  end
end
