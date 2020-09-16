class CreatePDMDMPatients < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :pd_mdm_patients
    end
  end
end
