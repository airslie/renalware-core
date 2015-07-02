class AddDoctorToPatients < ActiveRecord::Migration
  def change
    add_reference :patients, :doctor, index: true
  end
end
