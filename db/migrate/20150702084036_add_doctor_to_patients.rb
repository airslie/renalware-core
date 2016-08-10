class AddDoctorToPatients < ActiveRecord::Migration
  def change
    add_reference :patients, :doctor, index: true
    add_foreign_key :patients, :doctor_doctors, column: :doctor_id
  end
end
