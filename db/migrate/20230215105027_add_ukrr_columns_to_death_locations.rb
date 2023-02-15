class AddUkrrColumnsToDeathLocations < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      # These columns support mapping our locations to the new RR5 dataset Care Plan
      # outcome values
      add_column :death_locations, :rr_outcome_code, :integer, null: true
      add_column :death_locations, :rr_outcome_text, :string, null: true
    end
  end
end
