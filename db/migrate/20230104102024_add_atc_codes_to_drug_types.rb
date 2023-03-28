class AddAtcCodesToDrugTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :drug_types, :atc_codes, :string, array: true
  end
end
