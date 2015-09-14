module Renalware
  log '--------------------Adding ModalityCodes--------------------'

  file_path = File.join(default_path, 'modality_codes.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    ModalityCode.find_or_create_by!(code: row['code']) do |code|
      code.name = row['name']
    end
  end

  log "#{logcount} ModalityCodes seeded"
end