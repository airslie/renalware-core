module Renalware
  sitecode = 'BARTS'
  log "--------------------Adding #{sitecode} Modality Codes & Descriptions--------------------"

  file_path = File.join(default_path, 'modality_descriptions_barts.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    modalcode = row['code']
    modalname = row['name']
    Modalities::Description.find_or_create_by!(code: modalcode) do |code|
      code.name = modalname
    end
    log "--#{modalcode}: #{modalname}"
  end

  log "#{logcount} Modality Codes seeded"
end
