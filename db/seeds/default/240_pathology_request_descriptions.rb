module Renalware
  log '--------------------Adding Pathology Request Descriptions --------------------'

  file_path = File.join(default_path, 'pathology_request_descriptions.csv')
  labs = Pathology::Lab.all.index_by(&:name)

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    observation_description =
      if row["required_observation_description_code"].present?
        Pathology::ObservationDescription.find_by!(
          code: row["required_observation_description_code"]
        )
      end

    Pathology::RequestDescription.find_or_create_by!(
      code: row["code"],
      name: row["name"],
      lab: labs[row["lab"]],
      required_observation_description: observation_description,
      expiration_days: row["expiration_days"]
    )
  end

  log "#{logcount} Pathology Request Descriptions seeded"
end
