class DropDiagnosticsAndTreatments < ActiveRecord::Migration[7.0]
  def change
    drop_table :treatments, if_exists: true
    drop_table :diagnostics, if_exists: true
  end
end
