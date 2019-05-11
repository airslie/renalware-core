class CreateUKRDCModalityCodes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :ukrdc_modality_codes do |t|
        t.string :qbl_code, index: true
        t.string :txt_code, index: true
        t.text :description
        t.timestamps null: false
      end
    end
  end
end
