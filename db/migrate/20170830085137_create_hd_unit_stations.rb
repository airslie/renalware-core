class CreateHDUnitStations < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_stations do |t|
      t.references :hospital_unit, null: false, foreign_key: true, index: true
      t.integer :position, null: false, default: 0, index: true
      t.string :name
      t.string :location
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    add_foreign_key :hd_stations, :users, column: :created_by_id
    add_foreign_key :hd_stations, :users, column: :updated_by_id
  end
end
