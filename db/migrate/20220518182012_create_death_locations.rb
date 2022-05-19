class CreateDeathLocations < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :death_locations do |t|
        t.string :name, null: false
        t.datetime :deleted_at, index: true
        t.integer(
          :patients_preferred_count,
          default: 0,
          null: false,
          comment: "Counter cache for the number of patients preferring this location"
        )
        t.integer(
          :patients_actual_count,
          default: 0,
          null: false,
          comment: "Counter cache for the number of patients who died at this location"
        )
        t.timestamps null: false
        t.index(
          "TRIM(BOTH FROM LOWER(name))",
          unique: true,
          where: "deleted_at is null",
          name: "idx_death_locations_name"
        )
      end

      safety_assured do
        change_table :patients do |t|
          t.references :preferred_death_location, foreign_key: { to_table: :death_locations }
          t.text :preferred_death_location_notes
          t.references :actual_death_location, foreign_key: { to_table: :death_locations }
        end
      end
    end
  end
end
