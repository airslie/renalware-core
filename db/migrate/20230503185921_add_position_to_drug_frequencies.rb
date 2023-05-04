class AddPositionToDrugFrequencies < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_column :drug_frequencies, :position, :integer, default: 1, null: false
      add_index :drug_frequencies, :position, algorithm: :concurrently
    end
  end
end
