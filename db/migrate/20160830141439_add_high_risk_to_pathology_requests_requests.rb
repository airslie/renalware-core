class AddHighRiskToPathologyRequestsRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_requests_requests, :high_risk, :boolean, null: false
  end
end
