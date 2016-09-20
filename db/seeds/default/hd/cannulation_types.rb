module Renalware
  log "Adding HD Cannulation Types"

  file_path = File.join(File.dirname(__FILE__), "hd_cannulation_types.csv")

  CSV.foreach(file_path, headers: true) do |row|
    HD::CannulationType.find_or_create_by!(name: row["name"])
  end
end
