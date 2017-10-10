class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :system_countries do |t|
      t.string :name, null: false, index: :unique
      t.string :alpha2, null: false, index: :unique
      t.string :alpha3, null: false, index: :unique
      t.integer :position, index: :true
    end

    remove_column :addresses, :country, :string
    add_column :addresses, :country_id, :integer, index: true
    add_foreign_key :addresses, :system_countries, column: :country_id
  end
end
