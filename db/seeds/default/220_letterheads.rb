module Renalware
  log '--------------------Adding Letterheads --------------------'

  file_path = File.join(default_path, 'letterheads.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    name = "(#{row["sitecode"]}) #{row["unitinfo"]}"
    letterhead = Letters::Letterhead.find_or_initialize_by(name: name)
    letterhead.unit_info = row["unitinfo"]
    letterhead.trust_name = row["trustname"]
    letterhead.trust_caption = row["trustcaption"]
    letterhead.site_info_html = row["siteinfohtml"]
    letterhead.save!
  end

  log "#{logcount} HD Letterheads"
end