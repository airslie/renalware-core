log '--------------------Adding Organisms--------------------'

file_path = File.join(default_path, 'organisms.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  logcount += 1
  OrganismCode.find_or_create_by!(read_code: row['code']) do |code|
    code.name = row['name']
  end
end

log "#{logcount} Organisms seeded"
