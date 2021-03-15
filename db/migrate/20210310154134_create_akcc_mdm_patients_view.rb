class CreateAKCCMDMPatientsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :akcc_mdm_patients
    end
  end
end
