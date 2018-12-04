class AddRegionToAddresses < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :addresses, :region, :text, index: true
    end
  end
end
