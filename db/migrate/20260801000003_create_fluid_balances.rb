class CreateFluidBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :fluid_balances do |t|
      t.references :hospitalization, null: false, foreign_key: true
      t.references :recorded_by, foreign_key: { to_table: :users }
      t.string :balance_type, null: false
      t.string :fluid_type, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :unit, default: 'ml'
      t.datetime :recorded_at, null: false
      t.timestamps
    end
    add_index :fluid_balances, :recorded_at
  end
end
