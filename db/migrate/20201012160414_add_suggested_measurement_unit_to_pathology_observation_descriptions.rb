class AddSuggestedMeasurementUnitToPathologyObservationDescriptions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :pathology_observation_descriptions,
        :suggested_measurement_unit_id,
        :integer,
        null: true
      )

      add_foreign_key(
        :pathology_observation_descriptions,
        :pathology_measurement_units,
        column: :suggested_measurement_unit_id
      )
    end
  end
end
