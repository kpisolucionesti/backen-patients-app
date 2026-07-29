class AddServiceOrderFieldsToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :order_number, :string
    add_column :documents, :study_classification_id, :bigint
    add_column :documents, :study_type, :string
    add_column :documents, :observations, :text
    add_column :documents, :status, :string, default: 'requested'

    add_index :documents, :order_number, unique: true
    add_index :documents, :study_classification_id
    add_index :documents, :status

    add_foreign_key :documents, :clinical_study_classifications, column: :study_classification_id
  end
end
