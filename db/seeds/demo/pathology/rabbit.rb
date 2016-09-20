module Renalware
  rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
  pathology_rabbit = Pathology.cast_patient(rabbit)

  log "Adding Rabbit Pathology Requests (OBR)"

  CSV.foreach(File.join(File.dirname(__FILE__), "rabbit_pathology_obr.csv"), headers: true) do |row|
    request_description = Pathology::RequestDescription.find_by!(code: row["description"])
    pathology_rabbit.observation_requests.create!(
      id: row["id"],
      description: request_description,
      requestor_order_number: row["order_no"],
      requested_at: row["requested_at"],
      requestor_name: row["requestor_name"]
    )
  end

  log "Adding Rabbit Pathology Observations (OBX)"

  CSV.foreach(File.join(File.dirname(__FILE__), "rabbit_pathology_obx.csv"), headers: true) do |row|
    observation_description = Pathology::ObservationDescription.find_by!(code: row["description"])
    request = Pathology::ObservationRequest.find(row["request_id"])
    request.observations.create!(
      description: observation_description,
      result: row["result"],
      observed_at: request.requested_at - 9.hours
    )
  end
end
