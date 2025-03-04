class CreateDrugDMDMatches < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_dmd_matches do |t|
        t.references :drug, index: { unique: true }
        t.integer :prescriptions_count
        t.string :drug_name
        t.string :form_name
        t.string :vtm_name
        t.boolean :approved_vtm_match, default: false, null: false
        t.string :trade_family_name
        t.boolean :approved_trade_family_match, default: false
      end
    end
  end
end
