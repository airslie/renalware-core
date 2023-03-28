class CreateDrugTradeFamilies < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_trade_families do |t|
        t.string :name
        t.string :code, null: false, index: { unique: true }

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      safety_assured do
        add_reference :medication_prescriptions, :trade_family,
                      foreign_key: { to_table: :drug_trade_families }
      end
    end
  end
end
