module Renalware
  log "Adding Languages"

  file_path = File.join(File.dirname(__FILE__), 'patients_languages.csv')

  CSV.foreach(file_path, headers: true) do |row|
    Patients::Language.find_or_create_by!(name: row["name"])
  end
end
