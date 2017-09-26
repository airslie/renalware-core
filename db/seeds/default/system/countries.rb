module Renalware
  log "Adding Countries" do
    file_path = File.join(File.dirname(__FILE__), "countries.csv")
      CSV.foreach(file_path, headers: true) do |row, index|
        System::Country.find_or_create_by!(
          name: row["name"],
          alpha2: row["alpha2"],
          alpha3: row["alpha3"]
        ).tap{ |country| country.position = index }
    end
 end
end
