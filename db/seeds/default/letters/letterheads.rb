module Renalware
  log "Adding Letterheads"

  file_path = File.join(File.dirname(__FILE__), 'letterheads.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    name = "(#{row["site_code"]}) #{row["unit_info"]}"
    letterhead = Letters::Letterhead.find_or_initialize_by(name: name)
    letterhead.site_code = row["site_code"]
    letterhead.unit_info = row["unit_info"]
    letterhead.trust_name = row["trust_name"]
    letterhead.trust_caption = row["trust_caption"]
    letterhead.site_info = row["site_info"]
    letterhead.save!
  end

  log "#{logcount} Letterheads added", type: :sub
end
