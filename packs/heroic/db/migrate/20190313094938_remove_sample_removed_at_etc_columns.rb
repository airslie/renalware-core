class RemoveSampleRemovedAtEtcColumns < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      remove_column :biobank_samples, :removed_at, :datetime
      remove_column :biobank_samples, :removed_for_study, :string
    end
  end
end
