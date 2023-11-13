class AddIndexToDrugFrequencies < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_index :drug_frequencies, :name, unique: true
      end
    end
  end
end
