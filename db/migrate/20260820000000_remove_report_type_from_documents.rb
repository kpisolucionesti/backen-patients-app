class RemoveReportTypeFromDocuments < ActiveRecord::Migration[7.0]
  def change
    remove_column :documents, :report_type, :string
  end
end
