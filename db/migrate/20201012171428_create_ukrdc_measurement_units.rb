class CreateUKRDCMeasurementUnits < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :ukrdc_measurement_units do |t|
        t.string :name, null: false, index: :unique
        t.string :description, null: true
        t.timestamps null: false
      end

      add_reference(
        :pathology_measurement_units,
        :ukrdc_measurement_unit,
        index: { name: "index_pathology_measurement_units_ukrdc_mu" },
        null: true
      )
    end
  end
end
