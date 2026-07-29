class AddClassificationToLabParameters < ActiveRecord::Migration[7.0]
  def change
    add_reference :lab_parameters, :clinical_study_classification, foreign_key: true, null: true
  end
end
