class RemoveUniqueObrRequestorOrderNumberIndex < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_index :pathology_observation_requests, :requestor_order_number # was unique
      add_index :pathology_observation_requests, :requestor_order_number
    end
  end
end
