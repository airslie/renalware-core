class AddOrganisationNameToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :organisation_name, :string
  end
end
