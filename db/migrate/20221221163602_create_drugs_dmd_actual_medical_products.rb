class CreateDrugsDMDActualMedicalProducts < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_dmd_actual_medical_products do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name
        t.string :virtual_medical_product_code
        t.string :trade_family_code

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
