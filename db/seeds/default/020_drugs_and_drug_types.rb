module Renalware
  log '--------------------Adding DrugTypes--------------------'

  %w(Antibiotic ESA Immunosuppressant Peritonitis Controlled).each do |drug_type|
    Drugs::Type.find_or_create_by!(code: drug_type.downcase) do |type|
      type.name = drug_type
    end
  end

  log '--------------------Adding Drugs--------------------'

  file_path = File.join(default_path, 'drugs.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Drugs::Drug.find_or_create_by!(name: row['drugname'])
  end

  log "#{logcount} Drugs seeded"

  log '--------------------Assigning DrugTypes to Drugs--------------------'

  file_path = File.join(default_path, 'drug_drug_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    drug = Drugs::Drug.find(row['drug_id'])
    drug_type = Drugs::Type.find(row['drug_type_id'])
    drug.drug_types << drug_type unless drug.drug_types.include?(drug_type)
  end

  log "#{logcount} DrugTypes assigned"
end
