class CreateUserActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.text :description
      t.timestamps
    end
  end
end
