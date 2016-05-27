module Renalware
  log '--------------------Adding Pathology Request Descriptions --------------------'

  file_path = File.join(default_path, 'pathology_request_descriptions.csv')
  labs = Pathology::Lab.all.index_by(&:name)

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::RequestDescription.find_or_create_by!(
      code: row["code"],
      name: row["name"],
      lab: labs[row["lab"]]
    )
  end

  log "#{logcount} Pathology Request Descriptions seeded"
end
