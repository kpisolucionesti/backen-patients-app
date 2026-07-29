class CreateDynamicSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :dynamic_settings do |t|
      t.bigint :company_id, null: true
      t.string :category, null: false, default: 'general'
      t.jsonb :settings_data, null: false, default: {}
      t.jsonb :schema_definition, null: false, default: {}

      t.timestamps
    end

    add_index :dynamic_settings, [:company_id, :category], unique: true,
      name: 'idx_dynamic_settings_company_category'
    add_index :dynamic_settings, :category
    add_index :dynamic_settings, :company_id

    # FK will be added when companies table is created (future multi-tenancy)
  end
end
