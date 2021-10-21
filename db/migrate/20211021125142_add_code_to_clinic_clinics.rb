class AddCodeToClinicClinics < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_clinics, :code, :string
      add_index :clinic_clinics, :code, unique: true
    end
  end
end
