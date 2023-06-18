class AddDiagnosticToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :current_diagnostic, :string
  end
end
