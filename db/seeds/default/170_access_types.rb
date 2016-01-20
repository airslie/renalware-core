module Renalware
  log '--------------------Adding Access Types --------------------'

  file_path = File.join(default_path, 'access_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Accesses::Description.find_or_create_by!(code: row["code"]) do |site|
      site.name = row["name"]
    end
  end

  log "#{logcount} Access Types seeded"
end