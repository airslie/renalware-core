module Renalware
  log "Adding Hospitals"

  file_path = File.join(File.dirname(__FILE__), "hospital_centres.csv")

  CSV.foreach(file_path, headers: true) do |row|
    Hospitals::Centre.find_or_create_by!(code: row["code"]) do |hospital|
      hospital.name = row["name"]
      hospital.location = row["location"]
      hospital.active = true
      hospital.is_transplant_site = (row["is_transplant_site"] == "1")
    end
  end
end
