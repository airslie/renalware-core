class AddBottleTypeToPathologyRequestDescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_request_descriptions, :bottle_type, :string
  end
end
