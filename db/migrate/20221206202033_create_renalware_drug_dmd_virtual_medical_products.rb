class CreateRenalwareDrugDMDVirtualMedicalProducts < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_dmd_virtual_medical_products do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name
        t.string :form_code
        t.string :route_code
        t.string :atc_code
        t.string :unit_of_measure_code
        t.string :strength_numerator_value
        t.string :basis_of_strength
        t.string :virtual_therapeutic_moiety_code
        t.boolean :inactive, default: false

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
