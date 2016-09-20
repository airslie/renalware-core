module Renalware
  log "Adding Pathology Labs"

  file_path = File.join(File.dirname(__FILE__), 'pathology_labs.csv')

  CSV.foreach(file_path, headers: true) do |row|
    Pathology::Lab.find_or_create_by!(name: row["name"])
  end
end
