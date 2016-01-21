module Renalware
  log '--------------------Adding Access Sites --------------------'

  file_path = File.join(default_path, 'access_sites.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Accesses::Site.find_or_create_by!(code: row["code"]) do |site|
      site.name = row["name"]
    end
  end

  log "#{logcount} Access Sites seeded"
end