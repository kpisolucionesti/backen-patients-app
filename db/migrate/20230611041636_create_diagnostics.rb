class CreateDiagnostics < ActiveRecord::Migration[7.0]
  def change
    create_table :diagnostics do |t|
      t.references :patient
      t.references :doctor
      t.string :diagnostic
      t.timestamps
    end
  end
end
