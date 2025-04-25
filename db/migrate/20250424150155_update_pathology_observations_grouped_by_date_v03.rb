class UpdatePathologyObservationsGroupedByDateV03 < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :pathology_observations_grouped_by_date, version: 3, revert_to_version: 2
    end
  end
end
