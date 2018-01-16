class AddColumnsToDrugDrugs < ActiveRecord::Migration[5.1]
  def change
    # limit: 5 signals a bigint so we can store values like 3546611000001108
    add_column :drugs, :vmpid, :integer, limit: 5
    add_column :drugs, :description, :string
    add_index :drugs, :vmpid, unique: true, name: "idx_drugs_vmpid"
  end
end
