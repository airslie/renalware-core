module Renalware
  log '--------------------Adding Pathology Labs --------------------'

  file_path = File.join(default_path, 'pathology_labs.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::Lab.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} Pathology Labs seeded"
end
