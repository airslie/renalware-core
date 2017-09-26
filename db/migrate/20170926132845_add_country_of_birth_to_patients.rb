class AddCountryOfBirthToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :country_of_birth_id, :integer, index: true
    add_foreign_key :patients, :system_countries, column: :country_of_birth_id
  end
end
