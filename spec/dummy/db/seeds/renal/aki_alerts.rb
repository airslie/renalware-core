module Renalware
  log "Adding demo AKI Alerts" do
    action_ids = Renal::AKIAlertAction.pluck(:id)
    patient_ids = Patient.pluck(:id)
    hospital_ward_ids = Hospitals::Ward.pluck(:id)

    (1..5).each do |index|
      Renal::AKIAlert.create!(
        action_id: action_ids.sample,
        patient_id: patient_ids.sample,
        hospital_ward_id: hospital_ward_ids.sample,
        hotlist: [true, false].sample,
        notes: ""
      )
    end
  end
end
