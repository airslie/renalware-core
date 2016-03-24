module Renalware
  log '--------------------Adding Rabbit Pathology Results--------------------'
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  pathology_rabbit = Pathology.cast_patient(rabbit)
  request_description = Pathology::RequestDescription.first!

  logcount=0
  CSV.foreach(File.join(demo_path, 'rabbit_pathology.csv'), headers: true) do |row|
    logcount += 1
    requested_at = Time.zone.now - logcount.months
    request = pathology_rabbit.observation_requests.create!(
      description: request_description,
      requestor_order_number: "ABC#{logcount}",
      requested_at: requested_at,
      requestor_name: "Clinician ID #{logcount}",
    )
    #"HGB","WBC","LYM","NEUT","PLT","ESR","CRP","URE","CRE","NA","POT"

    observation_description = Pathology::ObservationDescription.find_by!(code: "HGB")
    request.observations.create!(
      description: observation_description,
      result: row['HGB'],
      observed_at: requested_at - 1.days
    )

    observation_description = Pathology::ObservationDescription.find_by!(code: "URE")
    request.observations.create!(
      description: observation_description,
      result: row['URE'],
      observed_at: requested_at - 1.days
    )

    observation_description = Pathology::ObservationDescription.find_by!(code: "WBC")
    request.observations.create!(
      description: observation_description,
      result: row['WBC'],
      observed_at: requested_at - 1.days
    )

    observation_description = Pathology::ObservationDescription.find_by!(code: "CRE")
    request.observations.create!(
      description: observation_description,
      result: row['CRE'],
      observed_at: requested_at - 1.days
    )
  end

  log "#{logcount} Path Results seeded"
end