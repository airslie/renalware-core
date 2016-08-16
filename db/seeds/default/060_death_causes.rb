module Renalware
  log '--------------------Adding Renal Reg Cause of Death codes--------------------'

  file_path = File.join(default_path, 'death_causes.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Deaths::EDTACode.find_or_create_by!(code: row['code']) do |code|
      code.death_cause = row['cause']
    end
  end

  log "#{logcount} Renal Reg Death Causes seeded"
end
