class ExtendVitalSigns < ActiveRecord::Migration[7.0]
  def change
    add_column :vital_signs, :glucose, :decimal, precision: 6, scale: 2
    add_column :vital_signs, :gcs_eye, :integer
    add_column :vital_signs, :gcs_verbal, :integer
    add_column :vital_signs, :gcs_motor, :integer
    add_column :vital_signs, :pupil_left, :string
    add_column :vital_signs, :pupil_right, :string
    add_column :vital_signs, :pain_scale, :integer
  end
end
