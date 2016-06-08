class AddDoctorIdToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :doctor_id, :integer

    add_foreign_key :clinics, :doctors
  end
end
