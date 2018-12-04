class AddUniqueConstraintToObrRequestor < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_index :pathology_observation_requests, :requestor_order_number, unique: true
    end
  end
end
