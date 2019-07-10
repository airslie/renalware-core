class AlterUKRDCTreatments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference :ukrdc_treatments, :hd_profile, index: true, foreign_key: true
      add_reference :ukrdc_treatments, :pd_regime, index: true, foreign_key: true
    end
  end
end
