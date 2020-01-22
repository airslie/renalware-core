class CreateTransplantMDMPatientsOpInPastYear < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :transplant_mdm_patients_op_in_past_year
    end
  end
end
