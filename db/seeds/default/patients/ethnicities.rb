module Renalware
  log "Adding Ethnicities" do

    file_path = File.join(File.dirname(__FILE__), "ethnicities.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Patients::Ethnicity.find_or_create_by!(name: row["name"])
    end
  end
end
