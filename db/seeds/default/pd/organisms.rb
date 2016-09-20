module Renalware
  log "Adding Organisms"

  file_path = File.join(File.dirname(__FILE__), 'organisms.csv')

  CSV.foreach(file_path, headers: true) do |row|
    PD::OrganismCode.find_or_create_by!(read_code: row['code']) do |code|
      code.name = row['name']
    end
  end
end
