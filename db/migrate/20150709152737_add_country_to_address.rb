class AddCountryToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :country, :string
  end
end
