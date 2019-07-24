class AddResultTypeToPathologyObservationDescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :pathology_observation_descriptions,
        :rr_type,
        :integer,
        default: 0,
        null: false
      )

      add_column(
        :pathology_observation_descriptions,
        :rr_coding_standard,
        :integer,
        default: 0,
        null: false
      )
    end
  end
end
