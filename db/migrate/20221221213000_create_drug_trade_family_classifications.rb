class CreateDrugTradeFamilyClassifications < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_trade_family_classifications do |t|
        t.references :drug, null: false, foreign_key: true
        t.references :trade_family, null: false, foreign_key: { to_table: :drug_trade_families }
        t.boolean :enabled, default: false, null: false

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }

        t.index [:drug_id, :trade_family_id],
                name: "index_drug_trade_family_class_on_drug_id_and_trade_family",
                unique: true
      end
    end
  end
end
