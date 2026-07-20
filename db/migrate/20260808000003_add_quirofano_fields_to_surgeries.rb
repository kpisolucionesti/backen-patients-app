class AddQuirofanoFieldsToSurgeries < ActiveRecord::Migration[7.0]
  def change
    add_column :surgeries, :area_id, :bigint
    add_column :surgeries, :patient_id, :bigint
    add_column :surgeries, :scheduled_start_time, :datetime
    add_column :surgeries, :scheduled_end_time, :datetime
    add_column :surgeries, :anesthesiologist, :string
    add_column :surgeries, :anesthesia_type, :string
    add_index :surgeries, :area_id
    add_index :surgeries, :patient_id
  end
end
