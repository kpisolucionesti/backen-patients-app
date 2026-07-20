class AddReportTypeToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :report_type, :string
  end
end
