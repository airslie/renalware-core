module Renalware
  log '--------------------Adding Hospitals --------------------'

  file_path = File.join(default_path, 'hospitals.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Hospital.find_or_create_by!(code: row["code"]) do |hospital|
      hospital.name = row["name"]
      hospital.location = row["location"]
      hospital.active = true
    end
  end

  log "#{logcount} Hospitals seeded"
end