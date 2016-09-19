module Renalware
  log '--------------------Adding Ethnicities--------------------'

  file_path = File.join(File.dirname(__FILE__), 'ethnicities.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Patients::Ethnicity.find_or_create_by!(name: row['name'])
  end

  log "#{logcount} Ethnicities seeded"
end
