class AddDoctorToPhysicalExams < ActiveRecord::Migration[7.0]
  def change
    add_reference :physical_exams, :doctor, foreign_key: true
  end
end
