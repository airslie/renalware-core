class AddDoctorIdToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :doctor_id, :integer
  end
end
