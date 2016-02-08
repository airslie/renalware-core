module Renalware
  log '--------------------Adding HD Cannulation Types --------------------'

  file_path = File.join(default_path, 'hd_cannulation_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    HD::CannulationType.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} HD Cannulation Types seeded"
end