module Renalware
  log "Adding Pathology Observation Descriptions"

  file_path = File.join(File.dirname(__FILE__), 'pathology_observation_descriptions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::ObservationDescription.find_or_create_by!(code: row["code"], name: row["name"])
  end

  log "#{logcount} Pathology Observation Descriptions seeded", type: :sub
end
