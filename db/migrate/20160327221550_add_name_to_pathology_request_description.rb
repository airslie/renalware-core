class AddNameToPathologyRequestDescription < ActiveRecord::Migration
  def change
    add_column :pathology_request_descriptions, :name, :string
  end
end
