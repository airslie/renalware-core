class AddUnitsToPathologyObservationDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :pathology_measurement_units do |t|
      t.string :name, null: false
      t.string :description, null: true
    end

    add_index :pathology_measurement_units, :name, unique: true

    add_column :pathology_observation_descriptions,
               :measurement_unit_id,
               :integer,
               null: false

    add_foreign_key :pathology_observation_descriptions,
                    :pathology_measurement_units,
                    column: :measurement_unit_id
  end
end
