class CreateHDStationLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_station_locations do |t|
      t.string :name, null: false, index: :unique
      t.string :colour, null: false
    end

    remove_column :hd_stations, :location, :string
    add_column :hd_stations, :location_id, :integer, null: true
    add_foreign_key :hd_stations, :hd_station_locations, column: :location_id
  end
end
