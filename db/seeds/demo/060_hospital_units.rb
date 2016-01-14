module Renalware
  log '--------------------Adding Hospital Units--------------------'

  file_path = File.join(default_path, 'hospital_units.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    hospital = Hospital.find_by code: row["hospital_code"]
    hospital.units.find_or_create_by!(unit_code: row["unit_code"]) do |unit|
      unit.name = row["name"]
      unit.renal_registry_code = row["renal_registry_code"]
      unit.unit_type = row["unit_type"]
      unit.is_hd_site = true
    end
  end

  log "#{logcount} Hospital Units seeded"
end