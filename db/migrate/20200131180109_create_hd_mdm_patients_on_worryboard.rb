class CreateHDMDMPatientsOnWorryboard < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :hd_mdm_patients_on_worryboard
    end
  end
end
