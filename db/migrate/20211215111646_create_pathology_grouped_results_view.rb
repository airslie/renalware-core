class CreatePathologyGroupedResultsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :pathology_observations_grouped_by_date
    end
  end
end
