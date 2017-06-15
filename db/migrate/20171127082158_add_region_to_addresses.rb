class AddRegionToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :region, :text, index: true
  end
end
