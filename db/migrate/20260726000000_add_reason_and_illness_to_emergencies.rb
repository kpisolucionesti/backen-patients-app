class AddReasonAndIllnessToEmergencies < ActiveRecord::Migration[7.0]
  def change
    add_column :emergencies, :reason_for_consultation, :text
    add_column :emergencies, :current_illness, :text
  end
end
