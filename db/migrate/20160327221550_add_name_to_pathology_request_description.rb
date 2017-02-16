class AddNameToPathologyRequestDescription < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_request_descriptions, :name, :string
  end
end
