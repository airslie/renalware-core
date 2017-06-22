class AddUniqueKeyToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :street_3, :string
    rename_column :addresses, :city, :town
    remove_index :addresses, [:addressable_type, :addressable_id]
    add_index :addresses, [:addressable_type, :addressable_id], unique: true
  end
end
