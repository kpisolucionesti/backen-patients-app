class AddEgressAtToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :egress_at, :datetime
  end
end
