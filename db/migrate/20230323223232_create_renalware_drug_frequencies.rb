class CreateRenalwareDrugFrequencies < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_frequencies do |t|
        t.string :name, null: false
        t.string :title, null: false

        t.timestamps null: false
      end
    end
  end
end
