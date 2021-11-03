class AddCounterCacheToObservationDescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :pathology_observation_descriptions,
        :observations_count,
        :integer,
        default: 0
      )

      add_column(
        :pathology_observation_descriptions,
        :last_observed_at,
        :datetime
      )
    end
  end
end
