class AddFillerOrderNumberToPathologyObservationRequests < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :pathology_observation_requests, :filler_order_number, :string
    end
  end
end
