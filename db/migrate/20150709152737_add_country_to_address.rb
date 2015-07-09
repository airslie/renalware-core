class AddCountryToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :country, :string
  end
end
