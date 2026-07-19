class UpdateVitalSignsAnthropometry < ActiveRecord::Migration[7.0]
  def change
    remove_column :vital_signs, :gcs_eye, :integer
    remove_column :vital_signs, :gcs_verbal, :integer
    remove_column :vital_signs, :gcs_motor, :integer
    remove_column :vital_signs, :pupil_left, :string
    remove_column :vital_signs, :pupil_right, :string
    remove_column :vital_signs, :pain_scale, :integer

    add_column :vital_signs, :height, :decimal, precision: 5, scale: 1
    add_column :vital_signs, :weight, :decimal, precision: 5, scale: 1
    add_column :vital_signs, :bmi, :decimal, precision: 4, scale: 1
  end
end
