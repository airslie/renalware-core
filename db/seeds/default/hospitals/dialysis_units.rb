module Renalware
  log '--------------------Adding Dialysis Units--------------------'

  file_path = File.join(File.dirname(__FILE__), 'dialysis_units.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    hospital = Hospitals::Centre.find_by code: row["hospital_centre_code"]
    hospital.units.find_or_create_by!(unit_code: row["unit_code"]) do |unit|
      unit.name = row["unit_name"]
      unit.renal_registry_code = row["renal_registry_code"]
      unit.unit_type = row["unit_type"]
      unit.is_hd_site = true
    end
  end

  log "#{logcount} Dialysis Units seeded"
end
