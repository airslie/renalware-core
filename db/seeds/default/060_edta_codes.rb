log '--------------------Adding EdtaCodes--------------------'

file_path = File.join(default_path, 'edta_codes.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  logcount += 1
  EdtaCode.find_or_create_by!(code: row['code']) do |code|
    code.death_cause = row['cause']
  end
end

log "#{logcount} EdtaCodes seeded"
