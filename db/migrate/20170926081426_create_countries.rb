class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :system_countries do |t|
      t.string :name, null: false, index: :unique
      t.string :alpha2, null: false, index: :unique
      t.string :alpha3, null: false, index: :unique
      t.integer :position, index: :true
    end
  end
end
