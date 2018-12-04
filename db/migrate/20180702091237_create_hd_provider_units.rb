class CreateHDProviderUnits < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table "renalware.hd_provider_units" do |t|
        t.references :hospital_unit, foreign_key: true, null: false
        t.references :hd_provider, foreign_key: true, null: false
        t.string :providers_reference, index: true
        t.timestamps null: false
      end
      add_index :hd_provider_units, [:hd_provider_id, :hospital_unit_id], unique: true
    end
  end
end
