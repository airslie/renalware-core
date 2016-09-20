module Renalware
  log "Adding Religions"

  file_path = File.join(File.dirname(__FILE__), 'patients_religions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Patients::Religion.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} religions seeded", type: :sub
end
