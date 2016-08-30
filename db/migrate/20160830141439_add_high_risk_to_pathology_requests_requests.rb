class AddHighRiskToPathologyRequestsRequests < ActiveRecord::Migration
  def change
    add_column :pathology_requests_requests, :high_risk, :boolean, null: false
  end
end
