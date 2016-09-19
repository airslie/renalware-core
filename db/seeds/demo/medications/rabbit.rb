module Renalware
  log '--------------------Adding Prescriptions for Roger RABBIT-------------------'
  barts_doc = User.find_by!(username: "bartsdoc")
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  rabbit.prescriptions.create!(
      drug_id: 183, treatable: rabbit,
      dose_amount: "25", dose_unit: "milligram", medication_route_id: 1, frequency: "nocte",
      prescribed_on: "2014-10-10", provider: 0, by: barts_doc
  )
  rabbit.prescriptions.create!(
      drug_id: 269, treatable: rabbit,
      dose_amount: "100", dose_unit: "milligram", medication_route_id: 1, frequency: "bd",
      prescribed_on: "2015-06-16", provider: 0, by: barts_doc
  )
  rabbit.prescriptions.create!(
    drug_id: 126, treatable: rabbit.peritonitis_episodes.first!,
    dose_amount: "100", dose_unit: "milligram", medication_route_id: 1, frequency: "tid for 7d",
    prescribed_on: "2015-09-21", provider: 0, by: barts_doc
  )
  rabbit.prescriptions.create!(
    drug_id: 986, treatable: rabbit,
    dose_amount: "50", dose_unit: "milligram", medication_route_id: 1, frequency: "bd for 7 days",
    prescribed_on: "2015-09-13", provider: 0, by: barts_doc,
    termination: Medications::PrescriptionTermination.new(terminated_on: "2015-09-20", by: barts_doc)
  )
end
