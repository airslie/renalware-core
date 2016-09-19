module Renalware
  log "--------------------Adding Pathology Requests Drug Categories --------------------"

  file_path = File.join(File.dirname(__FILE__), 'requests_drug_categories.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::Requests::DrugCategory.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} Drug Categories seeded"
end
