class AddActualTimesToSurgeries < ActiveRecord::Migration[7.0]
  def change
    add_column :surgeries, :actual_start_time, :datetime
    add_column :surgeries, :actual_end_time, :datetime
    add_column :surgeries, :ambulatory, :boolean, default: false
  end
end
