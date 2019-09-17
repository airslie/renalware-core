class AddHDTypeToUKRDCTreatments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :ukrdc_treatments, :hd_type, :string
    end
  end
end
