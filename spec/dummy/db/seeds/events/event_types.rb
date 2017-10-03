module Renalware
  log "Adding Demo Event Types" do
    file_path = File.join(File.dirname(__FILE__), "event_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Events::Type.find_or_create_by!(name: row["name"])
    end
  end
end
