module Renalware
  log "Adding Pathology Requests Drug Categories Drugs"

  file_path = File.join(File.dirname(__FILE__), 'requests_drugs_drug_categories.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    category = Pathology::Requests::DrugCategory.find_by(name: row["drug_category"])
    drug = Pathology::Requests::Drug.find_by(name: row["drug"])

    category.drugs << drug
  end

  log "#{logcount} Drug Categories Drugs seeded", type: :sub
end
