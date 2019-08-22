class AddLegacyCodeToPathologyObservationDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :pathology_observation_descriptions, :legacy_code, :string, index: { unique: true }
  end
end
