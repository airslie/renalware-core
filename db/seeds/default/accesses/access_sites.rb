module Renalware
  log "Adding Access Sites"

  file_path = File.join(File.dirname(__FILE__), "access_sites.csv")

  CSV.foreach(file_path, headers: true) do |row|
    Accesses::Site.find_or_create_by!(code: row["code"]) do |site|
      site.name = row["name"]
    end
  end
end
