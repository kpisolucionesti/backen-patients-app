class CreateClinicalCatalogs < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_routes do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :medication_presentations do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :medication_concentrations do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :medications do |t|
      t.string :name, null: false
      t.string :generic_name
      t.string :presentation
      t.string :concentration
      t.string :medication_route
      t.timestamps
    end

    create_table :diagnoses do |t|
      t.string :code, null: false
      t.string :description, null: false
      t.string :category
      t.timestamps
    end

    create_table :allergen_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :allergens do |t|
      t.string :name, null: false
      t.string :category
      t.timestamps
    end

    create_table :surgery_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :surgery_procedures do |t|
      t.string :code
      t.string :name, null: false
      t.string :category
      t.timestamps
    end

    create_table :anesthesia_types do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :discharge_types do |t|
      t.string :name, null: false
      t.boolean :requires_cause_of_death, default: false
      t.timestamps
    end

    create_table :vital_signs_ranges do |t|
      t.string :parameter, null: false
      t.string :sex
      t.integer :age_min
      t.integer :age_max
      t.decimal :min_normal, precision: 10, scale: 2
      t.decimal :max_normal, precision: 10, scale: 2
      t.decimal :min_alert, precision: 10, scale: 2
      t.decimal :max_alert, precision: 10, scale: 2
      t.timestamps
    end
  end
end
