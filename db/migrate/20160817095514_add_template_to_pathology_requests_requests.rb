class AddTemplateToPathologyRequestsRequests < ActiveRecord::Migration
  def change
    add_column :pathology_requests_requests, :template, :string, null: false
  end
end
