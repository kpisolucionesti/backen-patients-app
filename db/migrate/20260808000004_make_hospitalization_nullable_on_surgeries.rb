class MakeHospitalizationNullableOnSurgeries < ActiveRecord::Migration[7.0]
  def change
    change_column_null :surgeries, :hospitalization_id, true
  end
end
