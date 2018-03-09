class AddUniqueConstraintToObrRequestor < ActiveRecord::Migration[5.1]
  def change
    add_index :pathology_observation_requests, :requestor_order_number, unique: true
  end
end
