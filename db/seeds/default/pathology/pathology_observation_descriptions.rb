module Renalware
  log "Adding Pathology Observation Descriptions" do

    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")

    Pathology::ObservationDescription.transaction do
      values = CSV.read(file_path, headers: false)
      columns = values[0]
      Pathology::ObservationDescription.import! columns, values[1..-1], validate: true
    end
  end
end
