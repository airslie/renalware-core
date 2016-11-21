module Renalware
  log "Adding PD Episode Types" do
    file_path = File.join(File.dirname(__FILE__), "episode_types.csv")
    CSV.foreach(file_path, headers: true) do |row|
      PD::EpisodeType.find_or_create_by!(
        term: row["term"],
        definition: row["definition"]
      )
    end
  end
end
