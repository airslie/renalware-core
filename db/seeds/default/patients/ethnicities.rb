module Renalware
  log "Adding Renal Registry Ethnicities" do

    file_path = File.join(File.dirname(__FILE__), "ethnicity_codes.csv")
    CSV.foreach(file_path, headers: true) do |row|
      Patients::Ethnicity.find_or_create_by!(name: row["name"]) do |name|
        name.cfh_name = row["cfh_name"]
        name.rr18_code = row["rr18_code"]
      end
    end
  end
end
