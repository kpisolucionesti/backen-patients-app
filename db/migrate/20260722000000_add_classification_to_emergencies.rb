class AddClassificationToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :classification, :string
  end
end
