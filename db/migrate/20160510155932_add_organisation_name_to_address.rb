class AddOrganisationNameToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :organisation_name, :string
  end
end
