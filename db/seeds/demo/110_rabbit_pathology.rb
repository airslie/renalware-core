module Renalware
  log '--------------------Adding Rabbit Pathology Requests (OBR)--------------------'
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  pathology_rabbit = Pathology.cast_patient(rabbit)

  logcount=0
  CSV.foreach(File.join(demo_path, 'rabbit_pathology_obr.csv'), headers: true) do |row|
    #id,"order_no","requestor_name","requested_at",patient_id,"created_at","description"
    logcount += 1
    request_description = Pathology::RequestDescription.find_by!(code: row['description'])
    request = pathology_rabbit.observation_requests.create!(
      description: request_description,
      requestor_order_number: row['order_no'],
      requested_at: row['requested_at'],
      requestor_name: row['requestor_name']
    )
  end

  log "#{logcount} Path Requests seeded"
end
