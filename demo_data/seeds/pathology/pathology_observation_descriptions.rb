# frozen_string_literal: true

module Renalware
  log "Adding Pathology Observation Descriptions" do
    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")
    descriptions = []
    current_description_codes = Pathology::ObservationDescription.pluck(:code)
    units_of_measurement_map = Renalware::Pathology::MeasurementUnit.select(:id, :name)
      .each_with_object({}) { |uom, hash| hash[uom.name] = uom.id }

    Pathology::ObservationDescription.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        next if current_description_codes.include?(row["code"])

        descriptions << Pathology::ObservationDescription.new(
          code: row["code"],
          name: row["name"],
          measurement_unit_id: units_of_measurement_map[row["unit_of_measurement"]],
          loinc_code: row["loinc_code"],
          display_group: row["display_group"],
          display_order: row["display_order"],
          letter_group: row["letter_group"],
          letter_order: row["letter_order"]
        )
      end

      descriptions << Pathology::ObservationDescription.new(
        code: "PRODUCT CA PHOS",
        name: "Product of CA and PHOS",
        virtual: true,
        chart_sql_function_name: "pathology_chart_series_product_ca_phos",
        chart_colour: "orange",
        chart_logarithmic: false
      )

      Pathology::ObservationDescription.import!(descriptions)
    end
  end
end
