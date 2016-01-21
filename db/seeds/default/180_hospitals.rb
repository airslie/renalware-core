module Renalware
  log '--------------------Adding Hospitals --------------------'

  file_path = File.join(default_path, 'hospital_centres.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Hospitals::Centre.find_or_create_by!(code: row["code"]) do |hospital|
      hospital.name = row["name"]
      hospital.location = row["location"]
      hospital.active = true
      hospital.is_transplant_site = (row["is_transplant_site"] == "1")
    end
  end

  log "#{logcount} Hospitals seeded"
end