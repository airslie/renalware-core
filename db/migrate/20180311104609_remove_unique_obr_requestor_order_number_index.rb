class RemoveUniqueObrRequestorOrderNumberIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :pathology_observation_requests, :requestor_order_number # was unique
    add_index :pathology_observation_requests, :requestor_order_number
  end
end
