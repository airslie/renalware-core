module Renalware
  log '--------------------Adding Practices--------------------'
  logcount=0
  CSV.foreach(File.join(demo_path, 'practices.csv'), headers: true) do |row|
    next if row['street_1'].blank?

    logcount += 1
    practice = Practice.find_or_initialize_by(code: row['code'])

    practice.name = row['name']
    practice.email = row['email']
    practice.build_address(
      organisation_name: row['name'],
      postcode: row['postcode'],
      street_1: row['street_1'],
      street_2: row['street_2'],
      city: row['city']
    )

    practice.save!
  end
  log "#{logcount} Practices seeded"
end