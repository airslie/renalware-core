module Renalware
  log "Adding Event Types"

  file_path = File.join(File.dirname(__FILE__), 'event_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Events::Type.find_or_create_by!(name: row['eventtype'])
  end

  log "#{logcount} Event Types seeded", type: :sub
end
