class AddReportTypeAndMetadataToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :report_type, :string
    add_column :documents, :metadata, :jsonb, default: {}
  end
end
