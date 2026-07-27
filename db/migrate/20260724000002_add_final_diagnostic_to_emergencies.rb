class AddFinalDiagnosticToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :final_diagnostic, :string, limit: 2000
  end
end