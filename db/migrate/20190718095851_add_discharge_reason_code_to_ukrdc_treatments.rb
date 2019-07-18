class AddDischargeReasonCodeToUKRDCTreatments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :ukrdc_treatments, :discharge_reason_code, :integer
      add_column :ukrdc_treatments, :discharge_reason_comment, :string
    end
  end
end
