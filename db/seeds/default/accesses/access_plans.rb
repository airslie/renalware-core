module Renalware
  log "Adding Access Plans"

  file_path = File.join(File.dirname(__FILE__), "access_plans.csv")

  CSV.foreach(file_path, headers: true) do |row|
    Accesses::Plan.find_or_create_by!(name: row["name"])
  end
end
