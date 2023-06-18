class AddDoctorToPatient < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :current_doctor, :string
  end
end
