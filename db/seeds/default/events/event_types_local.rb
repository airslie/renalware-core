module Renalware
  log "Adding Local Event Types" do
    #change source .csv file as required. Pershaps useful to specify site in filename
    file_path = File.join(File.dirname(__FILE__), "event_types_blt.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Events::Type.find_or_create_by!(name: row["name"])
    end
  end
end
