class CreateParaclinicalStudies < ActiveRecord::Migration[7.0]
  def change
    create_table :paraclinical_studies do |t|
      t.references :emergency, null: false, foreign_key: true
      t.string :study_type, null: false
      t.text :description
      t.timestamps
    end
  end
end
