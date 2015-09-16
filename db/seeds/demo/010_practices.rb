module Renalware
  log '--------------------Adding Practices--------------------'
  logcount=0
  CSV.foreach(File.join(demo_path, 'practices.csv'), headers: true) do |row|
    logcount += 1
    address = Address.find_or_create_by(postcode: row['postcode'], street_1: row['street_1'], street_2: row['street_2'], city: row['city'])
    Practice.find_or_create_by(code: row['code']) do |practice|
      practice.name = row['name']
      practice.email = row['email']
      practice.address = address
    end
  end
  log "#{logcount} Practices seeded"
end