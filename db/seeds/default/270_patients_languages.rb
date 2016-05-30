module Renalware
  log '--------------------Adding Languages --------------------'

  file_path = File.join(default_path, 'patients_languages.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Patients::Language.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} languages seeded"
end
