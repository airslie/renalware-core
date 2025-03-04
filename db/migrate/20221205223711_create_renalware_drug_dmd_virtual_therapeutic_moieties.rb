class CreateRenalwareDrugDMDVirtualTherapeuticMoieties < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_dmd_virtual_therapeutic_moieties do |t|
        t.string :code, null: false, index: { unique: true, name: "index_drug_dmd_vtm_on_code" }
        t.string :name
        t.boolean :inactive, default: false, null: false

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
