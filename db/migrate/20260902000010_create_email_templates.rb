class CreateEmailTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :email_templates do |t|
      t.string :name, null: false
      t.string :subject, null: false
      t.text :body_html
      t.string :template_type, default: 'custom'
      t.jsonb :variables, default: []
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
    add_index :email_templates, :name, unique: true
  end
end
