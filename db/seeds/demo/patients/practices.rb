module Renalware
  log "Adding Practices"

  CSV.foreach(File.join(File.dirname(__FILE__), 'practices.csv'), headers: true) do |row|
    next if row['street_1'].blank?

    practice = Patients::Practice.find_or_initialize_by(code: row['code'])

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
end
