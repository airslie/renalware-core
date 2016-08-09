class AddBottleTypeToPathologyRequestDescriptions < ActiveRecord::Migration
  def change
    add_column :pathology_request_descriptions, :bottle_type, :string
  end
end
