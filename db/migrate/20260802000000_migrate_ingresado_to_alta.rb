class MigrateIngresadoToAlta < ActiveRecord::Migration[7.0]
  def up
    Emergency.where(status: 3).find_each do |emergency|
      emergency.update_columns(
        status: 2,
        egress_at: Time.current
      )
    end
  end

  def down
  end
end
