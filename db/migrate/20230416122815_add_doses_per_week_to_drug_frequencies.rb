class AddDosesPerWeekToDrugFrequencies < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :drug_frequencies,
                 :doses_per_week,
                 :decimal,
                 precision: 5,
                 scale: 2,
                 comment: "Examples: daily = 7, weekly = 1, twice daily = 14, monthly = 0.25"
    end
  end
end
