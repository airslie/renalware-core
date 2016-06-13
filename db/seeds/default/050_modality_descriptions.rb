module Renalware
  log '--------------------Adding Modality Codes & Descriptions--------------------'

  file_path = File.join(default_path, 'modality_descriptions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Modalities::Description.find_or_create_by!(code: row['code']) do |code|
      code.name = row['name']
    end
  end

  log "#{logcount} Modality Codes seeded"
end
