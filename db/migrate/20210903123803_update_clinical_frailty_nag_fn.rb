class UpdateClinicalFrailtyNagFn < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("patient_nag_clinical_frailty_score_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("patient_nag_clinical_frailty_score_v01.sql")
    end
  end
end
