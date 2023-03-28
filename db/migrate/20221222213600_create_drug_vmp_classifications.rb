class CreateDrugVMPClassifications < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_vmp_classifications do |t|
        t.references :drug, null: false, foreign_key: true
        t.string :code, null: false, index: { unique: true }
        t.references :form, foreign_key: { to_table: :drug_forms }
        t.references :route, foreign_key: { to_table: :medication_routes }
        t.references :unit_of_measure,
                     foreign_key: { to_table: :drug_unit_of_measures }
        t.integer :trade_family_ids, array: true, default: []

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
