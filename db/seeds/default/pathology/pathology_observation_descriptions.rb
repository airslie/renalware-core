module Renalware
  log "Adding Pathology Observation Descriptions"

  file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")

  CSV.foreach(file_path, headers: true) do |row|
    Pathology::ObservationDescription.find_or_create_by!(code: row["code"], name: row["name"])
  end
end
