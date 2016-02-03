module Renalware
  log '--------------------Adding HD Dialysers --------------------'

  file_path = File.join(default_path, 'hd_dialysers.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    HD::Dialyser.find_or_create_by!(group: row["group"], name: row["name"])
  end

  log "#{logcount} HD Dialysers seeded"
end