module Renalware
  log '--------------------Adding DrugTypes--------------------'

  %w(Antibiotic ESA Immunosuppressant Peritonitis Controlled).each do |drug_type|
    DrugType.find_or_create_by!(name: drug_type)
  end

  log '--------------------Adding Drugs--------------------'

  file_path = File.join(default_path, 'drugs.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Drug.find_or_create_by!(name: row['drugname'])
  end

  log "#{logcount} Drugs seeded"

  log '--------------------Assigning DrugTypes to Drugs--------------------'

  file_path = File.join(default_path, 'drug_drug_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    DrugDrugType.find_or_create_by!(drug_id: row['drug_id'], drug_type_id: row['drug_type_id'])
  end

  log "#{logcount} DrugTypes assigned"
end