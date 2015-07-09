log '--------------------Adding Ethnicities--------------------'

file_path = File.join(default_path, 'ethnicities.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  logcount += 1
  Ethnicity.find_or_create_by!(name: row['name'])
end

log "#{logcount} Ethnicities seeded"
