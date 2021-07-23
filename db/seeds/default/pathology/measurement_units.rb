# frozen_string_literal: true

module Renalware
  log "Adding Pathology Measurement Units" do
    file_path = File.join(File.dirname(__FILE__), "measurement_units.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Pathology::MeasurementUnit.find_or_create_by!(name: row["name"]) do |mu|
        mu.description = row["description"]
      end
    end
  end
end
