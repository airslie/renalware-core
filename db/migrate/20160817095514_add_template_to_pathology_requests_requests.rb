class AddTemplateToPathologyRequestsRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_requests_requests, :template, :string, null: false
  end
end
