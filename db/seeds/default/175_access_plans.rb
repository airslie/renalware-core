module Renalware
  log '--------------------Adding Access Plans --------------------'

  file_path = File.join(default_path, 'access_plans.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Accesses::Plan.find_or_create_by!(name: row["name"])
  end

  log "#{logcount} Access Plans seeded"
end