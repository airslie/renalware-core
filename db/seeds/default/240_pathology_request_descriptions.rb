module Renalware
  log '--------------------Adding Pathology Request Descriptions --------------------'

  file_path = File.join(default_path, 'pathology_request_descriptions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::RequestDescription.find_or_create_by!(code: row["code"], name: row["name"])
  end

  log "#{logcount} Pathology Request Descriptions seeded"
end
