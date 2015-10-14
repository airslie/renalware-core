module Renalware
  log '--------------------Adding PrdCodes--------------------'

  file_path = File.join(default_path, 'prd_descriptions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    PRDDescription.find_or_create_by!(code: row['code']) do |code|
      code.term = row['term']
    end
  end

  log "#{logcount} PrdCodes seeded"
end
