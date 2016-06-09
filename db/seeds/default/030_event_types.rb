module Renalware
  log '--------------------Adding Event Types--------------------'

  file_path = File.join(default_path, 'event_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Events::Type.find_or_create_by!(name: row['eventtype'])
  end

  log "#{logcount} Event Types seeded"
end
