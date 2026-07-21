class AddCancellationReasonToSurgeries < ActiveRecord::Migration[7.0]
  def change
    add_column :surgeries, :cancellation_reason, :text
  end
end
