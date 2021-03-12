class CreateAKCCMDMPatientsView < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_view :akcc_mdm_patients
    end
  end
end
