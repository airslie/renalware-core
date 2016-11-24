module Renalware
  log "Adding Pathology Observation Descriptions" do

    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")

    if Pathology::ObservationDescription.count == 0
      # bulk #import! for speed
      values = CSV.read(file_path, headers: false)
      columns = values[0]
      Pathology::ObservationDescription.import! columns, values[1..-1], validate: true
    else
      # idempotent alternative if we already have records
      CSV.foreach(file_path, headers: true) do |row|
        Pathology::ObservationDescription.find_or_create_by!(code: row["code"], name: row["name"])
      end
    end
  end
end
