module Renalware
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  pathology_rabbit = Pathology.cast_patient(rabbit)

  log '--------------------Adding Rabbit Pathology Requests (OBR)--------------------'

  logcount=0
  CSV.foreach(File.join(demo_path, 'rabbit_pathology_obr.csv'), headers: true) do |row|
    #id,"order_no","requestor_name","requested_at",patient_id,"created_at","description"
    logcount += 1
    request_description = Pathology::RequestDescription.find_by!(code: row['description'])
    request = pathology_rabbit.observation_requests.create!(
      id: row['id'],
      description: request_description,
      requestor_order_number: row['order_no'],
      requested_at: row['requested_at'],
      requestor_name: row['requestor_name']
    )
  end

  log "#{logcount} Path Requests seeded"

  log '--------------------Adding Rabbit Pathology Observations (OBX)--------------------'

  logcount=0
  CSV.foreach(File.join(demo_path, 'rabbit_pathology_obx.csv'), headers: true) do |row|
  #id,"result","comment","observed_at","created_at","description",request_id
    logcount += 1
    observation_description = Pathology::ObservationDescription.find_by!(code: row['description'])
    request = Pathology::ObservationRequest.find(row['request_id'])
    request.observations.create!(
      description: observation_description,
      result: row['result'],
      observed_at: request.requested_at - 12.hours
    )
  end

  log "#{logcount} Path Observations seeded"

end
