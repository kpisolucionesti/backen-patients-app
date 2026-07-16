class CreateTvScreenEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :tv_screen_events do |t|
      t.references :tv_screen, null: false, foreign_key: true
      t.string :event_type, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
