module Renalware
  log '--------------------Adding Letter Descriptions--------------------'
  logcount=0
  CSV.foreach(File.join(demo_path,'letter_descriptions.csv'), headers: true) do |row|
    logcount += 1
    Letters::Description.find_or_create_by(text: row['text'])
  end
  log "#{logcount} Letter Descriptions seeded"
end