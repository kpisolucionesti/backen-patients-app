class CreateClinicalStudyClassifications < ActiveRecord::Migration[7.0]
  def change
    create_table :clinical_study_classifications do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.string :color
      t.integer :sort_order, default: 0
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :clinical_study_classifications, :key, unique: true
  end
end
