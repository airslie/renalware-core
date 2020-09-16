class CreateHDMDMPatients < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :hd_mdm_patients
    end
  end
end
